# AI Adoption Advisor — Local Workspace

This workspace contains a minimal scaffold for the AI Adoption Platform website and a simple assessment backend.

Folders:
- `website/` — lightweight static frontend (HTML/CSS/JS).
- `assessment/` — FastAPI service exposing an `/assess` endpoint (placeholder logic).

Run the backend:

```bash
cd assessment
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Open the frontend by opening `website/index.html` in your browser (or serve it with a local static server).

Next steps:
- Implement assessment rules from the requirements PDF.
- Replace placeholder UI with final designs.
