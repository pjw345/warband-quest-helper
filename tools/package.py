from pathlib import Path
import sys, zipfile
r=Path(__file__).resolve().parents[1]
destination=Path(sys.argv[1] if len(sys.argv)>1 else 'WarbandQuestHelper-1.2.2.zip')
with zipfile.ZipFile(destination,'w',zipfile.ZIP_DEFLATED) as z:
 for p in sorted((r/'WarbandQuestHelper').iterdir()):
  if p.is_file():z.write(p,'WarbandQuestHelper/'+p.name)
print(destination)
