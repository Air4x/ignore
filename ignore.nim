import std/strutils, std/os

proc tags(entry: string):  string =
  var line: string
  var file: File
  discard file.open(entry)
  defer: file.close()
  while not file.endOfFile():
    line = readLine(file)
    if line.contains("#+filetags:"):
      return line
    else:
      line = ""
  return line

proc progetto(tag_line: string):  bool =
  if tag_line.contains("Progetti"):
    return true;
  return false;
  
proc area(tag_line: string): bool =
  if tag_line.contains("Area"):
    return true;
  return false;

when isMainModule:
  var tag_line: string
  var to_ignore: seq[string] = newSeqOfCap[string](10)
  const ignore_file_path: string = ".orgzlyignore"
  var ignore_file: File
  discard ignore_file.open(ignore_file_path)

  for file in walkFiles("*.org"):
    tag_line = tags(file)
    if tag_line == "":
      to_ignore.add(file)
    else:
      if (not progetto(tag_line)) and (not area(tag_line)):
        to_ignore.add(file)
    
  for file in to_ignore:
    writeLine(ignore_file, file)
    
  ignore_file.close()
