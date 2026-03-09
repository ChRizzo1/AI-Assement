from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional

app = FastAPI(title='AI Assessment Service')


class AssessmentRequest(BaseModel):
    size: Optional[str] = 'medium'
    data_readiness: Optional[int] = 3
    governance: Optional[str] = 'no'


class AssessmentResponse(BaseModel):
    score: int
    notes: str


@app.post('/assess', response_model=AssessmentResponse)
def assess(req: AssessmentRequest):
    # Placeholder scoring logic — replace with rules from the requirements doc
    score = 50
    score += (req.data_readiness - 3) * 10
    if req.governance == 'yes':
        score += 15
    if req.size == 'large':
        score += 5

    score = max(0, min(100, score))

    notes = 'Placeholder assessment. Integrate the full rubric from the requirements PDF.'
    return AssessmentResponse(score=score, notes=notes)
