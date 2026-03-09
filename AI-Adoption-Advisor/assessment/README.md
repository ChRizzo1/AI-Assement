# Assessment service

This folder contains a minimal FastAPI app that exposes `POST /assess` for a simple AI readiness score.

Run locally:

```bash
cd assessment
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The frontend at `website/index.html` will POST to `http://localhost:8000/assess`.
