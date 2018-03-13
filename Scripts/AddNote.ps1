<#
.Synopsis
  New-Note added to a file as a CSV line 
.Description
  Very simple start to adding notes to a text file but it's functional
.Example 
  New-Note "Pickup milk on way home" ToDo
.Parameter Content
  Text note(s) to add to file
.Parameter Category
  Category for filing - note will be added with each category
.Parameter Path
  File to use -- add to Categoies.txt file to add new categories
.Parameter Configuration
  Look up and match partial category names from this file
.Notes
  Just a start but functional
  ToDo:  Add more fields
  ToDo:  ???
  
#>
Function New-Note {
  [CmdletBinding()]param(
    [string[]]$Content,
    [string[]]$Category=@('Remember'),
    [string[]]$Path=@("$Home\Notes.txt"),
    [string]  $Configuration = "$Home\Categories.txt"
  )
  $Standard  = @('Remember','ToDo','Fun','Learn','PowerShell','FP') + 
                 (Import-CSV $Configuration -ea 0 | % { $_.Category } | select -uniq )
  $Content = $Content | % { $_ -split "`n" }
  $Date = Get-Date -f 's'
  $Category = $Category | % { 
    $Found = $Standard -match $_ 
    If ($Found) { $Found } else { $_ }
  }
  ForEach ($File in $Path) {
    ForEach ($Cat in $Category) {
      ForEach ($Line in $Content) {
        $Out = [pscustomobject]@{
          DateTime = $Date -f 's'
          Category = $Cat
          Content  = $Line
        }
        $Out | Export-Csv $File -append -notype
        $Out | Format-Table -HideTableHeader
      }  
    }     
  }  
}