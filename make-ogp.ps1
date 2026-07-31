# =====================================================================
#  駄菓子屋ゲームセンター OGP画像（1200x630）生成スクリプト
#
#  実行方法:
#      powershell -ExecutionPolicy Bypass -File .\make-ogp.ps1
#
#  出力: .\ogp.png
#  ※ このファイルは UTF-8（BOM付き）で保存すること。
#     BOMなしだと PowerShell 5.1 が日本語を化けさせて構文エラーになる。
# =====================================================================

Add-Type -AssemblyName System.Drawing

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$out  = Join-Path $here 'ogp.png'
$W = 1200; $H = 630

$CGreen  = [System.Drawing.Color]::FromArgb(255, 141, 255, 158)
$CGreenD = [System.Drawing.Color]::FromArgb(255, 108, 255, 142)
$CBlue   = [System.Drawing.Color]::FromArgb(255, 123, 214, 255)
$CPink   = [System.Drawing.Color]::FromArgb(255, 255, 107, 139)
$CYellow = [System.Drawing.Color]::FromArgb(255, 255, 224, 102)
$CInk    = [System.Drawing.Color]::FromArgb(255, 5, 6, 10)
$CGray   = [System.Drawing.Color]::FromArgb(255, 150, 190, 160)

$SP_OCTO = @(
  ".....##.....","...######...","..########..",".##.####.##.",
  "############","..###..###..",".##......##.","..##....##..")
$SP_SQUID = @(
  "....##....","...####...","..######..",".##.##.##.",
  "..######..","....##....","...#..#...","..#....#..")
$SP_CRAB = @(
  "..#.....#..","...#...#...","..#######..",".##.###.##.",
  "###########","#.#######.#","#.#.....#.#","...##.##...")

function Get-JpFont {
    param([single]$Size, [System.Drawing.FontStyle]$Style = [System.Drawing.FontStyle]::Bold)
    foreach ($name in @('Yu Gothic UI', 'Meiryo', 'Yu Gothic', 'MS Gothic', 'Arial')) {
        try {
            $f = New-Object System.Drawing.Font($name, $Size, $Style, [System.Drawing.GraphicsUnit]::Pixel)
            if ($f.Name -eq $name) { return $f }
            $f.Dispose()
        } catch { }
    }
    return New-Object System.Drawing.Font('Arial', $Size, $Style, [System.Drawing.GraphicsUnit]::Pixel)
}

function Draw-Sprite {
    param($G, [string[]]$Rows, [single]$X, [single]$Y, [single]$Px, [System.Drawing.Color]$Color)
    $b = New-Object System.Drawing.SolidBrush($Color)
    for ($r = 0; $r -lt $Rows.Count; $r++) {
        $line = $Rows[$r]
        for ($c = 0; $c -lt $line.Length; $c++) {
            if ($line[$c] -eq '#') {
                $G.FillRectangle($b, [single]($X + $c * $Px), [single]($Y + $r * $Px), [single]$Px, [single]$Px)
            }
        }
    }
    $b.Dispose()
}

function Draw-CenterText {
    param($G, [string]$Text, [single]$CenterX, [single]$Y, $Font,
          [System.Drawing.Color]$Color, [int]$GlowSize = 0)
    $sz = $G.MeasureString($Text, $Font)
    $x = $CenterX - $sz.Width / 2
    if ($GlowSize -gt 0) {
        $gb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(38, $Color.R, $Color.G, $Color.B))
        for ($i = 1; $i -le $GlowSize; $i++) {
            $o = [single]($i * 2)
            $G.DrawString($Text, $Font, $gb, [single]($x - $o), [single]$Y)
            $G.DrawString($Text, $Font, $gb, [single]($x + $o), [single]$Y)
            $G.DrawString($Text, $Font, $gb, [single]$x, [single]($Y - $o))
            $G.DrawString($Text, $Font, $gb, [single]$x, [single]($Y + $o))
        }
        $gb.Dispose()
    }
    $b = New-Object System.Drawing.SolidBrush($Color)
    $G.DrawString($Text, $Font, $b, [single]$x, [single]$Y)
    $b.Dispose()
}

$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$bg = New-Object System.Drawing.SolidBrush($CInk)
$g.FillRectangle($bg, 0, 0, $W, $H)
$bg.Dispose()

$cx = [single]($W / 2)
for ($i = 14; $i -ge 1; $i--) {
    $rad = [single]($W * 0.10 * $i / 3)
    $a = [int](3 + (14 - $i))
    $gb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($a, 20, 120, 60))
    $g.FillEllipse($gb, [single]($cx - $rad), [single]($H * 0.30 - $rad * 0.6), [single]($rad * 2), [single]($rad * 1.2))
    $gb.Dispose()
}

$sb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 255, 255, 255))
$rnd = New-Object System.Random(84)
for ($i = 0; $i -lt 130; $i++) {
    $g.FillRectangle($sb, [single]$rnd.Next(0, $W), [single]$rnd.Next(0, $H), [single]$rnd.Next(1, 4), [single]$rnd.Next(1, 4))
}
$sb.Dispose()

# インベーダー3体
$px = 7
$w1 = $SP_OCTO[0].Length * $px
$w2 = $SP_SQUID[0].Length * $px
$w3 = $SP_CRAB[0].Length * $px
$gap = $px * 6
$sx = $cx - ($w1 + $w2 + $w3 + $gap * 2) / 2
$rowY = [single]($H * 0.13)
Draw-Sprite $g $SP_OCTO  $sx $rowY $px $CPink
Draw-Sprite $g $SP_SQUID ([single]($sx + $w1 + $gap)) $rowY $px $CBlue
Draw-Sprite $g $SP_CRAB  ([single]($sx + $w1 + $gap + $w2 + $gap)) $rowY $px $CGreen

# タイトル
$fTitle = Get-JpFont 92
Draw-CenterText $g '駄菓子屋ゲームセンター' $cx ([single]($H * 0.30)) $fTitle $CGreenD 6
$fTitle.Dispose()

# サブ
$fSub = Get-JpFont 34 ([System.Drawing.FontStyle]::Regular)
Draw-CenterText $g 'ブラウザーで遊べる懐かしのゲーム' $cx ([single]($H * 0.53)) $fSub $CGray 0
$fSub.Dispose()

# バッジ
$fBadge = Get-JpFont 30
$txt = '無料・インストール不要・登録不要'
$sz = $g.MeasureString($txt, $fBadge)
$bw = $sz.Width + 56; $bh = $sz.Height + 20
$bx = $cx - $bw / 2; $by = [single]($H * 0.655)
$bb = New-Object System.Drawing.SolidBrush($CYellow)
$g.FillRectangle($bb, [single]$bx, [single]$by, [single]$bw, [single]$bh)
$bb.Dispose()
$fb = New-Object System.Drawing.SolidBrush($CInk)
$g.DrawString($txt, $fBadge, $fb, [single]($bx + 28), [single]($by + 10))
$fb.Dispose()
$fBadge.Dispose()

# URL
$fUrl = Get-JpFont 30 ([System.Drawing.FontStyle]::Regular)
Draw-CenterText $g 'yhdog0425-eng.github.io' $cx ([single]($H * 0.855)) $fUrl $CYellow 0
$fUrl.Dispose()

$pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 29, 77, 43), 4)
$g.DrawRectangle($pen, 2, 2, $W - 5, $H - 5)
$pen.Dispose()

$g.Dispose()
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "作成: $out ($W x $H)"
