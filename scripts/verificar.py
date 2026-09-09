"""Verificación de los servicios desde el Mac y de notebooks ejecutados."""
import json
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import urlopen

ROOT = Path(__file__).resolve().parents[1]
checks = [
    ("Página parte 4", "http://192.168.100.3:9000", "Bienvenidos al servidor de prueba"),
    ("Sitio personalizado", "http://192.168.100.3:9001", "Natalia Hernández"),
    ("Copia de directorios", "http://192.168.100.3:9910", "Prueba directorios"),
    ("Enlace segunda página", "http://192.168.100.3:9910/pagina1.html", "Página 1"),
    ("Bind mount anfitrión a contenedor", "http://192.168.100.3:9920/cambio.txt", "Cambio realizado"),
    ("Bind mount contenedor a anfitrión", "http://192.168.100.3:9920/desde-contenedor.txt", "Archivo escrito desde un contenedor"),
    ("Jupyter Iris", "http://192.168.100.3:8888", "Jupyter"),
    ("Jupyter repositorio", "http://192.168.100.3:8890", "Jupyter"),
    ("Flask", "http://192.168.100.3:5000", "my_articles"),
    ("Cliente con sitio personalizado descargado de Docker Hub", "http://192.168.100.2:9900", "Un laboratorio de ideas"),
]
results = []
for name, url, expected in checks:
    try:
        with urlopen(url, timeout=15) as response:
            body = response.read().decode()
            assert response.status == 200
            assert expected in body, f"No aparece: {expected}"
            if name == "Flask":
                assert len(json.loads(body)["my_articles"]) > 0
        results.append({"prueba": name, "url": url, "resultado": "OK"})
    except Exception as error:
        results.append({"prueba": name, "url": url, "resultado": "ERROR", "detalle": str(error)})

for notebook in ROOT.glob("**/*-ejecutado.ipynb"):
    doc = json.loads(notebook.read_text())
    cells = [c for c in doc["cells"] if c["cell_type"] == "code" and "".join(c["source"]).strip()]
    errors = [o for c in cells for o in c["outputs"] if o["output_type"] == "error"]
    ok = bool(cells) and not errors and all(c["execution_count"] is not None for c in cells)
    results.append({"prueba": notebook.name, "celdas_con_codigo": len(cells), "resultado": "OK" if ok else "ERROR"})

report = {"fecha_utc": datetime.now(timezone.utc).isoformat(), "pruebas": results}
(ROOT / "evidencias/verificacion.json").write_text(json.dumps(report, ensure_ascii=False, indent=2))
print(json.dumps(report, ensure_ascii=False, indent=2))
if any(r["resultado"] != "OK" for r in results):
    raise SystemExit(1)
