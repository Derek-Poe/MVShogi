$Global:boards = New-Object -TypeName PSCustomObject
$Global:boardNum = 0
$Global:prison = New-Object -TypeName PSCustomObject -Property ([ordered]@{1=@();2=@()})

function newBoard(){
  $Global:boardNum++
  $emSp = "" ; 1..(("$($Global:boardNum)-x-xx-x").Length) | % {$emSp += "."}
  $board = New-Object 'Object[,]' 9,9
  $i = 0; @("$($Global:boardNum)-2-l_-1","$($Global:boardNum)-2-k_-1","$($Global:boardNum)-2-s_-1","$($Global:boardNum)-2-g_-1","$($Global:boardNum)-2-ki-1","$($Global:boardNum)-2-g_-2","$($Global:boardNum)-2-s_-2","$($Global:boardNum)-2-k_-2","$($Global:boardNum)-2-l_-2") | % {$board[$i,0] += $_; $i++}
  $i = 0; @($emSp,"$($Global:boardNum)-2-r_-1",$emSp,$emSp,$emSp,$emSp,$emSp,"$($Global:boardNum)-2-b_-1",$emSp) | % {$board[$i,1] += $_; $i++}
  $i = 0; @("$($Global:boardNum)-2-p_-1","$($Global:boardNum)-2-p_-2","$($Global:boardNum)-2-p_-3","$($Global:boardNum)-2-p_-4","$($Global:boardNum)-2-p_-5","$($Global:boardNum)-2-p_-6","$($Global:boardNum)-2-p_-7","$($Global:boardNum)-2-p_-8","$($Global:boardNum)-2-p_-9") | % {$board[$i,2] += $_; $i++}
  3..5 | % { $i = $_; $ii = 0; @($emSp,$emSp,$emSp,$emSp,$emSp,$emSp,$emSp,$emSp,$emSp) | % {$board[$ii,$i] += $_; $ii++}}
  $i = 0; @("$($Global:boardNum)-1-p_-1","$($Global:boardNum)-1-p_-2","$($Global:boardNum)-1-p_-3","$($Global:boardNum)-1-p_-4","$($Global:boardNum)-1-p_-5","$($Global:boardNum)-1-p_-6","$($Global:boardNum)-1-p_-7","$($Global:boardNum)-1-p_-8","$($Global:boardNum)-1-p_-9") | % {$board[$i,6] += $_; $i++}
  $i = 0; @($emSp,"$($Global:boardNum)-1-b_-1",$emSp,$emSp,$emSp,$emSp,$emSp,"$($Global:boardNum)-1-r_-1",$emSp) | % {$board[$i,7] += $_; $i++}
  $i = 0; @("$($Global:boardNum)-1-l_-1","$($Global:boardNum)-1-k_-1","$($Global:boardNum)-1-s_-1","$($Global:boardNum)-1-g_-1","$($Global:boardNum)-1-ki-1","$($Global:boardNum)-1-g_-2","$($Global:boardNum)-1-s_-2","$($Global:boardNum)-1-k_-2","$($Global:boardNum)-1-l_-2") | % {$board[$i,8] += $_; $i++}
  $Global:boards | Add-Member -MemberType NoteProperty -Name $Global:boardNum -Value $board
}

function showBoard($selBoard,$player,$selPiece,$availMoves){
  $board = $Global:boards.($selBoard)
  if($board -ne $null){
    if($selPiece -ne $null){
      $selPieceInTemp = getSpaceIndex $selPiece
      $selPieceIn = "$($selPieceInTemp[0]),$($selPieceInTemp[1])"
    }
    if($availMoves -ne $null){
      $availMovesIn = @()
      forEach($availMove in $availMoves){
        $availMoveTemp = getSpaceIndex $availMove
        $availMovesIn += "$($availMoveTemp[0]),$($availMoveTemp[1])"
      }
    }
    $emSp = "" ; 1..(("$($selBoard)-x-xx-x").Length) | % {$emSp += "."}
    $ws = "" ; 1..(($board[0,0]).Length) | % {$ws += " "}
    Write-Host "`n`n`n`n`n`n`n`n`n`n" -NoNewline
    if($player -ne $null){
      Write-Host -f Green "Player: $player`n`n" -NoNewline
    }
    Write-Host -f Gray "9$ws`8$ws`7$ws`6$ws`5$ws`4$ws`3$ws`2$ws`1$ws`n`n" -NoNewline
    $char = 65
    for($i = 0; $i -lt 9; $i++){
      for($ii = 0; $ii -lt 9; $ii++){
        $in = "$ii,$i"
        if($in -in $availMovesIn){
          Write-Host -f Red "$($board[$ii,$i]) " -NoNewline
        }
        elseIf($board[$ii,$i] -eq $emSp){
          Write-Host -f DarkCyan "$emSp " -NoNewline
        }
        elseIf($board[$ii,$i].Split("-")[1] -eq $player -or $player -eq $null){
          if($selPiece -eq $null){
            Write-Host -f Yellow "$($board[$ii,$i]) " -NoNewline
          }
          else{
            if($in -eq $selPieceIn){
              Write-Host -f Magenta "$($board[$ii,$i]) " -NoNewline
            }
            else{
              Write-Host -f DarkYellow "$($board[$ii,$i]) " -NoNewline
            }
          }
        }
        else{
          Write-Host -f White "$($board[$ii,$i]) " -NoNewline
        }
      }
      Write-Host -f Gray "  $([char]$char)`n" -NoNewline
      $char++
    }
  }
  else{
    Write-Host -f Magenta "Null Board"
  }
}

function getSpaceIndex($loc){
  $loc = $loc.ToLower()
  if((($loc.Substring(0,1) -as [int]) -gt 0 -and ($loc.Substring(0,1) -as [int]) -lt 10) -and $loc.Substring(1,1) -match '[a-i]'){
    switch($loc.Substring(0,1)){
      "1" {
        $in1 = 8
        break
      }
      "2" {
        $in1 = 7
        break
      }
      "3" {
        $in1 = 6
        break
      }
      "4" {
        $in1 = 5
        break
      }
      "5" {
        $in1 = 4
        break
      }
      "6" {
        $in1 = 3
        break
      }
      "7" {
        $in1 = 2
        break
      }
      "8" {
        $in1 = 1
        break
      }
      "9" {
        $in1 = 0
        break
      }
    }
    switch($loc.Substring(1,1)){
      "a" {
        $in2 = 0
        break
      }
      "b" {
        $in2 = 1
        break
      }
      "c" {
        $in2 = 2
        break
      }
      "d" {
        $in2 = 3
        break
      }
      "e" {
        $in2 = 4
        break
      }
      "f" {
        $in2 = 5
        break
      }
      "g" {
        $in2 = 6
        break
      }
      "h" {
        $in2 = 7
        break
      }
      "i" {
        $in2 = 8
        break
      }
    }
    return @($in1,$in2)
  }
  else{
    return "Invalid Location"
  }
}

function getSpaceLoc($in){
  $loc = ""
  switch($in[0]){
    0 {
      $loc += "9"
      break
    }
    1 {
      $loc += "8"
      break
    }
    2 {
      $loc += "7"
      break
    }
    3 {
      $loc += "6"
      break
    }
    4 {
      $loc += "5"
      break
    }
    5 {
      $loc += "4"
      break
    }
    6 {
      $loc += "3"
      break
    }
    7 {
      $loc += "2"
      break
    }
    8 {
      $loc += "1"
      break
    }
  }
  $loc += [char](65 + $in[1])
  return $loc
}

function getAvailMoves($selBoard,$loc){
  $locIn = getSpaceIndex $loc
  $x = $locIn[0]; $y = $locIn[1]
  $x = $x -as [int]; $y = $y -as [int]
  $piece = $Global:boards.($selBoard)[$x,$y]
  $piece = $piece -as [String]
  $pPos = $piece.split("-")[1]
  $pType = $piece.split("-")[2]
  $emSp = "" ; 1..(("$($selBoard)-x-xx-x").Length) | % {$emSp += "."}
  if($piece.split("-")[1] -eq "1"){
    $pDir = -1
  }
  elseIf($piece.split("-")[1] -eq "2"){
    $pDir = 1
  }
  $moveSet = @()
  switch($pType){
    {$_ -eq "g_" -or $_ -eq "p+" -or $_ -eq "s+" -or $_ -eq "k+" -or $_ -eq "l+"} {
      $m1x = $x
      $m1y = ($y + (1 * $pDir))
      if(($m1x -ge 0 -and $m1x -lt 10) -and ($m1y -ge 0 -and $m1y -lt 10)){
        if($Global:boards.($selBoard)[$m1x,$m1y] -eq $emSp -or ($Global:boards.($selBoard)[$m1x,$m1y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m1x,$m1y)
        }
      }
      $m2x = $x - 1
      $m2y = ($y + (1 * $pDir))
      if(($m2x -ge 0 -and $m2x -lt 10) -and ($m2y -ge 0 -and $m2y -lt 10)){
        if($Global:boards.($selBoard)[$m2x,$m2y] -eq $emSp -or ($Global:boards.($selBoard)[$m2x,$m2y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m2x,$m2y)
        }
      }
      $m3x = $x + 1
      $m3y = ($y + (1 * $pDir))
      if(($m3x -ge 0 -and $m3x -lt 10) -and ($m3y -ge 0 -and $m3y -lt 10)){
        if($Global:boards.($selBoard)[$m3x,$m3y] -eq $emSp -or ($Global:boards.($selBoard)[$m3x,$m3y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m3x,$m3y)
        }
      }
      $m4x = $x - 1
      $m4y = $y
      if(($m4x -ge 0 -and $m4x -lt 10) -and ($m4y -ge 0 -and $m4y -lt 10)){
        if($Global:boards.($selBoard)[$m4x,$m4y] -eq $emSp -or ($Global:boards.($selBoard)[$m4x,$m4y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m4x,$m4y)
        }
      }
      $m5x = $x + 1
      $m5y = $y
      if(($m5x -ge 0 -and $m5x -lt 10) -and ($m5y -ge 0 -and $m5y -lt 10)){
        if($Global:boards.($selBoard)[$m5x,$m5y] -eq $emSp -or ($Global:boards.($selBoard)[$m5x,$m5y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m5x,$m5y)
        }
      }
      $m6x = $x
      $m6y = ($y - (1 * $pDir))
      if(($m6x -ge 0 -and $m6x -lt 10) -and ($m6y -ge 0 -and $m6y -lt 10)){
        if($Global:boards.($selBoard)[$m6x,$m6y] -eq $emSp -or ($Global:boards.($selBoard)[$m6x,$m6y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m6x,$m6y)
        }
      }
      return $moveSet
      break
    }
    "p_" {
      $m1x = $x
      $m1y = ($y + (1 * $pDir))
      if(($m1x -ge 0 -and $m1x -lt 10) -and ($m1y -ge 0 -and $m1y -lt 10)){
        if($Global:boards.($selBoard)[$m1x,$m1y] -eq $emSp -or ($Global:boards.($selBoard)[$m1x,$m1y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m1x,$m1y)
        }
      }
      return $moveSet
      break
    }
    "l_" {
      $searchMove = $true
      $m1ys = $y
      while($searchMove){
        $m1x = $x
        $m1y = ($m1ys + (1 * $pDir))
        if(($m1x -ge 0 -and $m1x -lt 10) -and ($m1y -ge 0 -and $m1y -lt 10)){
          if($Global:boards.($selBoard)[$m1x,$m1y] -ne $emSp){
            $searchMove = $false
          }
          if(($Global:boards.($selBoard)[$m1x,$m1y]).Split("-")[1] -ne $pPos){
            #Write-Host -f DarkYellow $Global:boards.($selBoard)[$m1x,$m1y]
            $moveSet += getSpaceLoc @($m1x,$m1y)
          }
          $m1ys = $m1y        
        }
        else{
          $searchMove = $false
        }
      }
      return $moveSet
      break
    }
    "r_" {
      forEach($mDir in @(1, -1)){
        $searchMove = $true
        $m1ys = $y
        while($searchMove){
          $m1x = $x
          $m1y = ($m1ys + (1 * $mDir))
          if(($m1x -ge 0 -and $m1x -lt 10) -and ($m1y -ge 0 -and $m1y -lt 10)){
            if($Global:boards.($selBoard)[$m1x,$m1y] -ne $emSp){
              $searchMove = $false
            }
            if(($Global:boards.($selBoard)[$m1x,$m1y]).Split("-")[1] -ne $pPos){
              #Write-Host -f DarkYellow $Global:boards.($selBoard)[$m1x,$m1y]
              $moveSet += getSpaceLoc @($m1x,$m1y)
            }
            $m1ys = $m1y        
          }
          else{
            $searchMove = $false
          }
        }
      }
      forEach($mDir in @(1, -1)){
        $searchMove = $true
        $m2xs = $x
        while($searchMove){
          $m2x = ($m2xs + (1 * $mDir))
          $m2y = $y
          if(($m2x -ge 0 -and $m2x -lt 10) -and ($m2y -ge 0 -and $m2y -lt 10)){
            if($Global:boards.($selBoard)[$m2x,$m2y] -ne $emSp){
              $searchMove = $false
            }
            if(($Global:boards.($selBoard)[$m2x,$m2y]).Split("-")[1] -ne $pPos){
              #Write-Host -f DarkYellow $Global:boards.($selBoard)[$m2x,$m2y]
              $moveSet += getSpaceLoc @($m2x,$m2y)
            }
            $m2xs = $m2x        
          }
          else{
            $searchMove = $false
          }
        }
      }
      return $moveSet
      break
    }
    "b_" {
      forEach($mDir in @(1, -1)){
        $searchMove = $true
        $m1xs = $x
        $m1ys = $y
        while($searchMove){
          $m1x = ($m1xs + (1 * $mDir))
          $m1y = ($m1ys - (1 * $mDir))
          if(($m1x -ge 0 -and $m1x -lt 10) -and ($m1y -ge 0 -and $m1y -lt 10)){
            if($Global:boards.($selBoard)[$m1x,$m1y] -ne $emSp){
              $searchMove = $false
            }
            if(($Global:boards.($selBoard)[$m1x,$m1y]).Split("-")[1] -ne $pPos){
              #Write-Host -f DarkYellow $Global:boards.($selBoard)[$m1x,$m1y]
              $moveSet += getSpaceLoc @($m1x,$m1y)
            }
            $m1xs = $m1x
            $m1ys = $m1y        
          }
          else{
            $searchMove = $false
          }
        }
      }
      forEach($mDir in @(1, -1)){
        $searchMove = $true
        $m2ys = $y
        $m2xs = $x
        while($searchMove){
          $m2x = ($m2xs + (1 * $mDir))
          $m2y = ($m2ys + (1 * $mDir))
          if(($m2x -ge 0 -and $m2x -lt 10) -and ($m2y -ge 0 -and $m2y -lt 10)){
            if($Global:boards.($selBoard)[$m2x,$m2y] -ne $emSp){
              $searchMove = $false
            }
            if(($Global:boards.($selBoard)[$m2x,$m2y]).Split("-")[1] -ne $pPos){
              #Write-Host -f DarkYellow $Global:boards.($selBoard)[$m2x,$m2y]
              $moveSet += getSpaceLoc @($m2x,$m2y)
            }
            $m2xs = $m2x
            $m2ys = $m2y      
          }
          else{
            $searchMove = $false
          }
        }
      }
      return $moveSet
      break
    }
    "k_" {
      $m1x = $x + 1
      $m1y = ($y + (2 * $pDir))
      if(($m1x -ge 0 -and $m1x -lt 10) -and ($m1y -ge 0 -and $m1y -lt 10)){
        if($Global:boards.($selBoard)[$m1x,$m1y] -eq $emSp -or ($Global:boards.($selBoard)[$m1x,$m1y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m1x,$m1y)
        }
      }
      $m2x = $x - 1
      $m2y = ($y + (2 * $pDir))
      if(($m2x -ge 0 -and $m2x -lt 10) -and ($m2y -ge 0 -and $m2y -lt 10)){
        if($Global:boards.($selBoard)[$m2x,$m2y] -eq $emSp -or ($Global:boards.($selBoard)[$m2x,$m2y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m2x,$m2y)
        }
      }
      return $moveSet
      break
    }
    "s_" {
      $m1x = $x
      $m1y = ($y + (1 * $pDir))
      if(($m1x -ge 0 -and $m1x -lt 10) -and ($m1y -ge 0 -and $m1y -lt 10)){
        if($Global:boards.($selBoard)[$m1x,$m1y] -eq $emSp -or ($Global:boards.($selBoard)[$m1x,$m1y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m1x,$m1y)
        }
      }
      $m2x = $x - 1
      $m2y = ($y + (1 * $pDir))
      if(($m2x -ge 0 -and $m2x -lt 10) -and ($m2y -ge 0 -and $m2y -lt 10)){
        if($Global:boards.($selBoard)[$m2x,$m2y] -eq $emSp -or ($Global:boards.($selBoard)[$m2x,$m2y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m2x,$m2y)
        }
      }
      $m3x = $x + 1
      $m3y = ($y + (1 * $pDir))
      if(($m3x -ge 0 -and $m3x -lt 10) -and ($m3y -ge 0 -and $m3y -lt 10)){
        if($Global:boards.($selBoard)[$m3x,$m3y] -eq $emSp -or ($Global:boards.($selBoard)[$m3x,$m3y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m3x,$m3y)
        }
      }
      $m4x = $x - 1
      $m4y = ($y - (1 * $pDir))
      if(($m4x -ge 0 -and $m4x -lt 10) -and ($m4y -ge 0 -and $m4y -lt 10)){
        if($Global:boards.($selBoard)[$m4x,$m4y] -eq $emSp -or ($Global:boards.($selBoard)[$m4x,$m4y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m4x,$m4y)
        }
      }
      $m5x = $x + 1
      $m5y = ($y - (1 * $pDir))
      if(($m5x -ge 0 -and $m5x -lt 10) -and ($m5y -ge 0 -and $m5y -lt 10)){
        if($Global:boards.($selBoard)[$m5x,$m5y] -eq $emSp -or ($Global:boards.($selBoard)[$m5x,$m5y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m5x,$m5y)
        }
      }
      return $moveSet
      break
    }
    "ki" {
      $m1x = $x
      $m1y = ($y + (1 * $pDir))
      if(($m1x -ge 0 -and $m1x -lt 10) -and ($m1y -ge 0 -and $m1y -lt 10)){
        if($Global:boards.($selBoard)[$m1x,$m1y] -eq $emSp -or ($Global:boards.($selBoard)[$m1x,$m1y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m1x,$m1y)
        }
      }
      $m2x = $x - 1
      $m2y = ($y + (1 * $pDir))
      if(($m2x -ge 0 -and $m2x -lt 10) -and ($m2y -ge 0 -and $m2y -lt 10)){
        if($Global:boards.($selBoard)[$m2x,$m2y] -eq $emSp -or ($Global:boards.($selBoard)[$m2x,$m2y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m2x,$m2y)
        }
      }
      $m3x = $x + 1
      $m3y = ($y + (1 * $pDir))
      if(($m3x -ge 0 -and $m3x -lt 10) -and ($m3y -ge 0 -and $m3y -lt 10)){
        if($Global:boards.($selBoard)[$m3x,$m3y] -eq $emSp -or ($Global:boards.($selBoard)[$m3x,$m3y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m3x,$m3y)
        }
      }
      $m4x = $x - 1
      $m4y = $y
      if(($m4x -ge 0 -and $m4x -lt 10) -and ($m4y -ge 0 -and $m4y -lt 10)){
        if($Global:boards.($selBoard)[$m4x,$m4y] -eq $emSp -or ($Global:boards.($selBoard)[$m4x,$m4y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m4x,$m4y)
        }
      }
      $m5x = $x + 1
      $m5y = $y
      if(($m5x -ge 0 -and $m5x -lt 10) -and ($m5y -ge 0 -and $m5y -lt 10)){
        if($Global:boards.($selBoard)[$m5x,$m5y] -eq $emSp -or ($Global:boards.($selBoard)[$m5x,$m5y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m5x,$m5y)
        }
      }
      $m6x = $x
      $m6y = ($y - (1 * $pDir))
      if(($m6x -ge 0 -and $m6x -lt 10) -and ($m6y -ge 0 -and $m6y -lt 10)){
        if($Global:boards.($selBoard)[$m6x,$m6y] -eq $emSp -or ($Global:boards.($selBoard)[$m6x,$m6y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m6x,$m6y)
        }
      }
      $m7x = $x - 1
      $m7y = ($y - (1 * $pDir))
      if(($m7x -ge 0 -and $m7x -lt 10) -and ($m7y -ge 0 -and $m7y -lt 10)){
        if($Global:boards.($selBoard)[$m7x,$m7y] -eq $emSp -or ($Global:boards.($selBoard)[$m7x,$m7y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m7x,$m7y)
        }
      }
      $m8x = $x + 1
      $m8y = ($y - (1 * $pDir))
      if(($m8x -ge 0 -and $m8x -lt 10) -and ($m8y -ge 0 -and $m8y -lt 10)){
        if($Global:boards.($selBoard)[$m8x,$m8y] -eq $emSp -or ($Global:boards.($selBoard)[$m8x,$m8y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m8x,$m8y)
        }
      }
      return $moveSet
      break
    }
    "r+" {
      forEach($mDir in @(1, -1)){
        $searchMove = $true
        $m1ys = $y
        while($searchMove){
          $m1x = $x
          $m1y = ($m1ys + (1 * $mDir))
          if(($m1x -ge 0 -and $m1x -lt 10) -and ($m1y -ge 0 -and $m1y -lt 10)){
            if($Global:boards.($selBoard)[$m1x,$m1y] -ne $emSp){
              $searchMove = $false
            }
            if(($Global:boards.($selBoard)[$m1x,$m1y]).Split("-")[1] -ne $pPos){
              #Write-Host -f DarkYellow $Global:boards.($selBoard)[$m1x,$m1y]
              $moveSet += getSpaceLoc @($m1x,$m1y)
            }
            $m1ys = $m1y        
          }
          else{
            $searchMove = $false
          }
        }
      }
      forEach($mDir in @(1, -1)){
        $searchMove = $true
        $m2xs = $x
        while($searchMove){
          $m2x = ($m2xs + (1 * $mDir))
          $m2y = $y
          if(($m2x -ge 0 -and $m2x -lt 10) -and ($m2y -ge 0 -and $m2y -lt 10)){
            if($Global:boards.($selBoard)[$m2x,$m2y] -ne $emSp){
              $searchMove = $false
            }
            if(($Global:boards.($selBoard)[$m2x,$m2y]).Split("-")[1] -ne $pPos){
              #Write-Host -f DarkYellow $Global:boards.($selBoard)[$m2x,$m2y]
              $moveSet += getSpaceLoc @($m2x,$m2y)
            }
            $m2xs = $m2x        
          }
          else{
            $searchMove = $false
          }
        }
      }
      $m3x = $x + 1
      $m3y = ($y + (1 * $pDir))
      if(($m3x -ge 0 -and $m3x -lt 10) -and ($m3y -ge 0 -and $m3y -lt 10)){
        if($Global:boards.($selBoard)[$m3x,$m3y] -eq $emSp -or ($Global:boards.($selBoard)[$m3x,$m3y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m3x,$m3y)
        }
      }
      $m4x = $x - 1
      $m4y = ($y + (1 * $pDir))
      if(($m4x -ge 0 -and $m4x -lt 10) -and ($m4y -ge 0 -and $m4y -lt 10)){
        if($Global:boards.($selBoard)[$m4x,$m4y] -eq $emSp -or ($Global:boards.($selBoard)[$m4x,$m4y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m4x,$m4y)
        }
      }
      $m5x = $x + 1
      $m5y = ($y - (1 * $pDir))
      if(($m5x -ge 0 -and $m5x -lt 10) -and ($m5y -ge 0 -and $m5y -lt 10)){
        if($Global:boards.($selBoard)[$m5x,$m5y] -eq $emSp -or ($Global:boards.($selBoard)[$m5x,$m5y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m5x,$m5y)
        }
      }
      $m6x = $x - 1
      $m6y = ($y - (1 * $pDir))
      if(($m6x -ge 0 -and $m6x -lt 10) -and ($m6y -ge 0 -and $m6y -lt 10)){
        if($Global:boards.($selBoard)[$m6x,$m6y] -eq $emSp -or ($Global:boards.($selBoard)[$m6x,$m6y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m6x,$m6y)
        }
      }
      return $moveSet
      break
    }
    "b+" {
      forEach($mDir in @(1, -1)){
        $searchMove = $true
        $m1xs = $x
        $m1ys = $y
        while($searchMove){
          $m1x = ($m1xs + (1 * $mDir))
          $m1y = ($m1ys - (1 * $mDir))
          if(($m1x -ge 0 -and $m1x -lt 10) -and ($m1y -ge 0 -and $m1y -lt 10)){
            if($Global:boards.($selBoard)[$m1x,$m1y] -ne $emSp){
              $searchMove = $false
            }
            if(($Global:boards.($selBoard)[$m1x,$m1y]).Split("-")[1] -ne $pPos){
              #Write-Host -f DarkYellow $Global:boards.($selBoard)[$m1x,$m1y]
              $moveSet += getSpaceLoc @($m1x,$m1y)
            }
            $m1xs = $m1x
            $m1ys = $m1y        
          }
          else{
            $searchMove = $false
          }
        }
      }
      forEach($mDir in @(1, -1)){
        $searchMove = $true
        $m2ys = $y
        $m2xs = $x
        while($searchMove){
          $m2x = ($m2xs + (1 * $mDir))
          $m2y = ($m2ys + (1 * $mDir))
          if(($m2x -ge 0 -and $m2x -lt 10) -and ($m2y -ge 0 -and $m2y -lt 10)){
            if($Global:boards.($selBoard)[$m2x,$m2y] -ne $emSp){
              $searchMove = $false
            }
            if(($Global:boards.($selBoard)[$m2x,$m2y]).Split("-")[1] -ne $pPos){
              #Write-Host -f DarkYellow $Global:boards.($selBoard)[$m2x,$m2y]
              $moveSet += getSpaceLoc @($m2x,$m2y)
            }
            $m2xs = $m2x
            $m2ys = $m2y      
          }
          else{
            $searchMove = $false
          }
        }
      }
      $m3x = $x
      $m3y = ($y + (1 * $pDir))
      if(($m3x -ge 0 -and $m3x -lt 10) -and ($m3y -ge 0 -and $m3y -lt 10)){
        if($Global:boards.($selBoard)[$m3x,$m3y] -eq $emSp -or ($Global:boards.($selBoard)[$m3x,$m3y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m3x,$m3y)
        }
      }
      $m4x = $x
      $m4y = ($y - (1 * $pDir))
      if(($m4x -ge 0 -and $m4x -lt 10) -and ($m4y -ge 0 -and $m4y -lt 10)){
        if($Global:boards.($selBoard)[$m4x,$m4y] -eq $emSp -or ($Global:boards.($selBoard)[$m4x,$m4y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m4x,$m4y)
        }
      }
      $m5x = $x + 1
      $m5y = $y
      if(($m5x -ge 0 -and $m5x -lt 10) -and ($m5y -ge 0 -and $m5y -lt 10)){
        if($Global:boards.($selBoard)[$m5x,$m5y] -eq $emSp -or ($Global:boards.($selBoard)[$m5x,$m5y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m5x,$m5y)
        }
      }
      $m6x = $x - 1
      $m6y = $y
      if(($m6x -ge 0 -and $m6x -lt 10) -and ($m6y -ge 0 -and $m6y -lt 10)){
        if($Global:boards.($selBoard)[$m6x,$m6y] -eq $emSp -or ($Global:boards.($selBoard)[$m6x,$m6y]).Split("-")[1] -ne $pPos){
          $moveSet += getSpaceLoc @($m6x,$m6y)
        }
      }
      return $moveSet
      break
    }
  }
}

function movePiece($selBoard,$orig,$dest){
  #promotion check for Origin and Destination

  $origIn = getSpaceIndex $orig
  $destIn = getSpaceIndex $dest
  $emSp = "" ; 1..(("$($selBoard)-x-xx-x").Length) | % {$emSp += "."}
  if($Global:boards.($selBoard)[$destIn] -eq $emSp){
    $Global:boards.($selBoard)[$destIn] = $Global:boards.($selBoard)[$origIn]
    $Global:boards.($selBoard)[$origIn] = $emSp
  }
  elseIf(($Global:boards.($selBoard)[$destIn]).Split("-")[1] -ne ($Global:boards.($selBoard)[$origIn]).Split("-")[1]){
    $Global:prison.(($Global:boards.($selBoard)[$origIn]).Split("-")[1]) += ($Global:boards.($selBoard)[$destIn]).ToLower()
    $Global:boards.($selBoard)[$destIn] = $Global:boards.($selBoard)[$origIn]
    $Global:boards.($selBoard)[$origIn] = $emSp
  }

  #Assign Promotion Status
}

function promotionCheck($pieceIn){
  #Promotion Zone is Last 3 Ranks
  #Can Promote Upon Entering, Moving Through, or Exiting
  #Promotion Forced on Pawns and Lances in the Last Rank or Knights in the Last 2 Ranks
}

function promotePiece($pieceIn){
  #If piece is promotable(~), then promote(+)
  #Else Error
}

function dropPiece($selBoard,$piece,$dest){
  #Must be able to move (Pawns, Knights, Lances)
  #Only 1 Unpromoted Pawn in file
  #No checkmating the King
  #Unpromoted upon drop
}

function newMV($selBoard,$origIn,$destIn){
  #If more than one move is available, 
  #Clone current board 
  #then randomly move piece to one of the moves not selected
}

function guidedMovePiece($player){
  function selectPlayer(){
    $player = Read-Host "`nSelect Player (1 or 2)"
    $player = ($player -as [int])
    if($player -gt 0 -and $player -le 2){
      return $player 
    }
    else{
      Write-Host -f Magenta "Invalid Selection"
      pause
      selectPlayer
    }
  }
  function selectBoard(){
    $boardsAvail = $Global:boards.PSObject.Properties.Name.Length
    if($boardsAvail -ne 1){
      $boardChoice = Read-Host "`nSelect Board ($boardsAvail Available)"
      $boardChoice = ($boardChoice -as [int])
      if($boardChoice -gt 0 -and $boardChoice -le $boardsAvail){
        return $boardChoice
      }
      else{
        Write-Host -f Magenta "Invalid Selection"
        pause
        selectBoard
      }
    }
    else{
      return 1
    }
  }
  function selectPiece($boardChoice,$player){
    showBoard $boardChoice $player
    $pieceChoice = Read-Host "`nSelect Piece"
    $pieceChoice = $pieceChoice.ToUpper()
    if($Global:boards.($boardChoice)[(getSpaceIndex $pieceChoice)].Split("-")[1] -eq ($player -as [String])){
      return $pieceChoice
    }
    else{
      Write-Host -f Magenta "Invalid Selection"
      pause
      selectPiece $boardChoice $player
    }
  }
  function selectMove($boardChoice,$player,$pieceChoice){
    $availMoves = getAvailMoves $boardChoice $pieceChoice
    showBoard $boardChoice $player $pieceChoice $availMoves
    $moveChoice = Read-Host "`nSelect Move"
    $moveChoice = $moveChoice.ToUpper()
    if($moveChoice -in $availMoves){
      return $moveChoice
    }
    else{
      Write-Host -f Magenta "Invalid Selection"
      pause
      selectMove $boardChoice $player $pieceChoice
    }
  }
  function guidedMovePieceMaster($player){
    if($player -eq $null){
      $player = selectPlayer
    }
    $boardChoice = selectBoard
    $pieceChoice = selectPiece $boardChoice $player
    $moveChoice = selectMove $boardChoice $player $pieceChoice
    movepiece $boardChoice $pieceChoice $moveChoice
    showBoard $boardChoice $null $null $null
    #newMV
  }
  guidedMovePieceMaster $player
}

newBoard
#guidedMovePiece
#getAvailMoves 1 "9A"
#movePiece 1 "9C" "9D"
#showBoard 1 1 "5G" @("5F","5E","5D","5C")

while(1){
  guidedMovePiece 1
  guidedMovePiece 2
}
