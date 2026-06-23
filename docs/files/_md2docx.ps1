param([string[]]$Files)

# --- helpers ---
function HexToBgr([string]$hex){
  $hex = $hex.TrimStart('#')
  $r=[Convert]::ToInt32($hex.Substring(0,2),16)
  $g=[Convert]::ToInt32($hex.Substring(2,2),16)
  $b=[Convert]::ToInt32($hex.Substring(4,2),16)
  return ($r + $g*256 + $b*65536)
}
$cTitle = HexToBgr "1F3A5F"
$cH1    = HexToBgr "1F3A5F"
$cH2    = HexToBgr "C55A11"
$cH3    = HexToBgr "333333"
$cQuote = HexToBgr "5A2D08"
$cHdrBg = HexToBgr "1F3A5F"

function Type-Inline($sel,[string]$text){
  # split on ** for bold toggling
  $parts = $text -split '\*\*'
  for($i=0;$i -lt $parts.Count;$i++){
    if($parts[$i].Length -gt 0){
      $sel.Font.Bold = [int]($i % 2)   # odd index = bold
      $sel.TypeText($parts[$i])
    }
  }
  $sel.Font.Bold = 0
}

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

foreach($file in $Files){
  $full = (Resolve-Path $file).Path
  $lines = Get-Content -Path $full -Encoding UTF8
  $doc = $word.Documents.Add()
  $doc.Content.ParagraphFormat.ReadingOrder = 1   # RTL whole doc
  $sel = $word.Selection
  $sel.ParagraphFormat.ReadingOrder = 1
  $sel.ParagraphFormat.Alignment = 2              # right
  $base = "Segoe UI"
  $sel.Font.Name = $base
  $sel.Font.Size = 11

  $i = 0
  while($i -lt $lines.Count){
    $ln = $lines[$i]
    $t  = $ln.Trim()

    # --- table block ---
    if($t.StartsWith("|")){
      $tbl = @()
      while($i -lt $lines.Count -and $lines[$i].Trim().StartsWith("|")){
        $tbl += $lines[$i].Trim(); $i++
      }
      # parse rows (skip separator row of dashes)
      $rows = @()
      foreach($r in $tbl){
        if($r -match '^\|[\s:\-\|]+\|?$'){ continue }   # separator
        $cells = $r.Trim('|') -split '\|' | ForEach-Object { ($_ -replace '\*\*','').Trim() }
        $rows += ,$cells
      }
      if($rows.Count -gt 0){
        $nc = $rows[0].Count
        $rng = $sel.Range
        $table = $doc.Tables.Add($rng, $rows.Count, $nc)
        $table.Borders.Enable = 1
        $table.Range.ParagraphFormat.ReadingOrder = 1
        $table.Range.Font.Size = 10
        $table.Range.Font.Name = $base
        for($ri=0;$ri -lt $rows.Count;$ri++){
          for($ci=0;$ci -lt $nc;$ci++){
            $val = ""
            if($ci -lt $rows[$ri].Count){ $val = $rows[$ri][$ci] }
            $cell = $table.Cell($ri+1,$ci+1)
            $cell.Range.Text = $val
            if($ri -eq 0){
              $cell.Range.Font.Bold = 1
              $cell.Range.Font.Color = 16777215   # white
              $cell.Shading.BackgroundPatternColor = $cHdrBg
            }
          }
        }
        $word.Selection.EndKey(6) | Out-Null   # wdStory? use move below
        # move cursor after table
        $doc.Content.InsertParagraphAfter()
        $sel.EndKey(6) | Out-Null
      }
      continue
    }

    $i++

    if($t.Length -eq 0){ $sel.TypeParagraph(); continue }
    if($t -eq "---"){
      $sel.ParagraphFormat.Alignment = 2
      $sel.TypeText( (([char]0x2500).ToString() * 30) ); $sel.TypeParagraph(); continue
    }

    # headings
    if($t.StartsWith("# ")){
      $sel.Font.Size = 20; $sel.Font.Bold = 1; $sel.Font.Color = $cTitle
      $sel.ParagraphFormat.Alignment = 1
      $sel.TypeText($t.Substring(2)); $sel.TypeParagraph()
      $sel.Font.Size=11;$sel.Font.Bold=0;$sel.Font.Color=0;$sel.ParagraphFormat.Alignment=2; continue
    }
    if($t.StartsWith("## ")){
      $sel.TypeParagraph()
      $sel.Font.Size = 15; $sel.Font.Bold = 1; $sel.Font.Color = $cH1
      $sel.TypeText($t.Substring(3)); $sel.TypeParagraph()
      $sel.Font.Size=11;$sel.Font.Bold=0;$sel.Font.Color=0; continue
    }
    if($t.StartsWith("### ")){
      $sel.Font.Size = 13; $sel.Font.Bold = 1; $sel.Font.Color = $cH2
      $sel.TypeText($t.Substring(4)); $sel.TypeParagraph()
      $sel.Font.Size=11;$sel.Font.Bold=0;$sel.Font.Color=0; continue
    }
    # quote / note
    if($t.StartsWith("> ")){
      $sel.Font.Size = 10; $sel.Font.Italic = 1; $sel.Font.Color = $cQuote
      Type-Inline $sel (([char]0x25C6).ToString() + " " + $t.Substring(2))
      $sel.TypeParagraph()
      $sel.Font.Size=11;$sel.Font.Italic=0;$sel.Font.Color=0; continue
    }
    # code fence (collect until closing ```)
    if($t.StartsWith('```')){
      $sel.Font.Name="Consolas";$sel.Font.Size=9
      while($i -lt $lines.Count -and -not $lines[$i].Trim().StartsWith('```')){
        $sel.TypeText($lines[$i]); $sel.TypeParagraph(); $i++
      }
      $i++   # skip closing fence
      $sel.Font.Name=$base;$sel.Font.Size=11; continue
    }
    # bullet
    if($t.StartsWith("- ")){
      $sel.ParagraphFormat.LeftIndent = 18
      Type-Inline $sel (([char]0x2022).ToString() + "  " + $t.Substring(2))
      $sel.TypeParagraph(); $sel.ParagraphFormat.LeftIndent = 0; continue
    }
    # numbered
    if($t -match '^\d+\.\s'){
      $sel.ParagraphFormat.LeftIndent = 18
      Type-Inline $sel $t
      $sel.TypeParagraph(); $sel.ParagraphFormat.LeftIndent = 0; continue
    }
    # normal paragraph
    Type-Inline $sel $t
    $sel.TypeParagraph()
  }

  $out = [System.IO.Path]::ChangeExtension($full, ".docx")
  $doc.SaveAs([ref]$out, [ref]16)   # 16 = wdFormatDocumentDefault (.docx)
  $doc.Close()
  Write-Output ("SAVED: " + $out)
}

$word.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
