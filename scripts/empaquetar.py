"""Crea el paquete de entrega sin claves, tokens, cachés ni entorno auxiliar."""
from pathlib import Path
import hashlib
import json
import zipfile

root = Path(__file__).resolve().parents[1]
excluded = {'.git', '.runtime', '.vagrant', '__pycache__', '.ipynb_checkpoints'}
files = [p for p in root.rglob('*') if p.is_file()
         and not excluded.intersection(p.relative_to(root).parts)
         and p.name not in {'.DS_Store', '.env', 'MANIFIESTO.json'}
         and not p.name.startswith('._') and p.suffix not in {'.pem', '.token'}]
manifest = [{"archivo": str(p.relative_to(root)), "sha256": hashlib.sha256(p.read_bytes()).hexdigest(),
             "bytes": p.stat().st_size} for p in sorted(files)]
manifest_path = root / 'MANIFIESTO.json'
manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2))
output = root.parent / 'Practica-Docker-IA-Natalia-Hernandez.zip'
with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED) as z:
    for p in files + [manifest_path]:
        z.write(p, Path(root.name) / p.relative_to(root))
with zipfile.ZipFile(output) as z:
    assert z.testzip() is None
    assert all(not excluded.intersection(Path(n).parts) for n in z.namelist())
print(f'{output}\n{len(files)+1} archivos / {output.stat().st_size:,} bytes')
