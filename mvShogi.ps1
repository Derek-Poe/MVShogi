$Global:boards = New-Object -TypeName PSCustomObject
$Global:boardNum = 0
$Global:prison = New-Object -TypeName PSCustomObject -Property ([ordered]@{1=@();2=@()})

function newBoard(){
  $Global:boardNum++
  $emSp = "" ; 1..(("$($Global:boardNum)-x-xx-x").Length) | % {$emSp += "."}
  $board = New-Object 'Object[,]' 9,9
  $i = 0; @("$($Global:boardNum)-2-la-1","$($Global:boardNum)-2-kn-1","$($Global:boardNum)-2-si-1","$($Global:boardNum)-2-go-1","$($Global:boardNum)-2-ki-1","$($Global:boardNum)-2-go-2","$($Global:boardNum)-2-si-2","$($Global:boardNum)-2-kn-2","$($Global:boardNum)-2-la-2") | % {$board[$i,0] += $_; $i++}
  $i = 0; @($emSp,"$($Global:boardNum)-2-ro-1",$emSp,$emSp,$emSp,$emSp,$emSp,"$($Global:boardNum)-2-bi-1",$emSp) | % {$board[$i,1] += $_; $i++}
  $i = 0; @("$($Global:boardNum)-2-pa-1","$($Global:boardNum)-2-pa-2","$($Global:boardNum)-2-pa-3","$($Global:boardNum)-2-pa-4","$($Global:boardNum)-2-pa-5","$($Global:boardNum)-2-pa-6","$($Global:boardNum)-2-pa-7","$($Global:boardNum)-2-pa-8","$($Global:boardNum)-2-pa-9") | % {$board[$i,2] += $_; $i++}
  3..5 | % { $i = $_; $ii = 0; @($emSp,$emSp,$emSp,$emSp,$emSp,$emSp,$emSp,$emSp,$emSp) | % {$board[$ii,$i] += $_; $ii++}}
  $i = 0; @("$($Global:boardNum)-1-pa-1","$($Global:boardNum)-1-pa-2","$($Global:boardNum)-1-pa-3","$($Global:boardNum)-1-pa-4","$($Global:boardNum)-1-pa-5","$($Global:boardNum)-1-pa-6","$($Global:boardNum)-1-pa-7","$($Global:boardNum)-1-pa-8","$($Global:boardNum)-1-pa-9") | % {$board[$i,6] += $_; $i++}
  $i = 0; @($emSp,"$($Global:boardNum)-1-bi-1",$emSp,$emSp,$emSp,$emSp,$emSp,"$($Global:boardNum)-1-ro-1",$emSp) | % {$board[$i,7] += $_; $i++}
  $i = 0; @("$($Global:boardNum)-1-la-1","$($Global:boardNum)-1-kn-1","$($Global:boardNum)-1-si-1","$($Global:boardNum)-1-go-1","$($Global:boardNum)-1-ki-1","$($Global:boardNum)-1-go-2","$($Global:boardNum)-1-si-2","$($Global:boardNum)-1-kn-2","$($Global:boardNum)-1-la-2") | % {$board[$i,8] += $_; $i++}
  $Global:boards | Add-Member -MemberType NoteProperty -Name $Global:boardNum -Value $board
}

function showBoard($board){
  if($board -ne $null){
    $ws = "" ; 1..(($board[0,0]).Length) | % {$ws += " "}
    $boardView = "9$ws`8$ws`7$ws`6$ws`5$ws`4$ws`3$ws`2$ws`1$ws`n`n"
    #$char = 97
    $char = 65
    for($i = 0; $i -lt 9; $i++){
      for($ii = 0; $ii -lt 9; $ii++){
        $boardView += "$($board[$ii,$i]) "
      }
      $boardView += "  $([char]$char)`n"
      $char++
    }
    Write-Host -f Yellow "`n`n`n`n$boardView"
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
  $pPos = $piece.split("-")[2]
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
    "pa" {
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
  }
}

function movePiece($selBoard,$orig,$dest){
  $origIn = getSpaceIndex $orig
  $destIn = getSpaceIndex $dest
  $emSp = "" ; 1..(("$($selBoard)-x-xx-x").Length) | % {$emSp += "."}
  #$origPlayer = ($Global:boards.($selBoard)[$origIn]).Split("-")[1]
  if($Global:boards.($selBoard)[$destIn] -eq $emSp){
    $Global:boards.($selBoard)[$destIn] = $Global:boards.($selBoard)[$origIn]
    $Global:boards.($selBoard)[$origIn] = $emSp
  }
  elseIf(($Global:boards.($selBoard)[$destIn]).Split("-")[1] -ne ($Global:boards.($selBoard)[$origIn]).Split("-")[1]){
    $Global:prison.(($Global:boards.($selBoard)[$origIn]).Split("-")[1]) += $Global:boards.($selBoard)[$destIn]
    $Global:boards.($selBoard)[$destIn] = $Global:boards.($selBoard)[$origIn]
    $Global:boards.($selBoard)[$origIn] = $emSp
  }
}

newBoard
showBoard $Global:boards.(1)
getAvailMoves 1 "9C"
movePiece 1 "9C" "9D"
