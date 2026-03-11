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
    score = 0
    notes = []

    # Organization size impact
    if req.size == 'small':
        score += 10
        notes.append("Small organizations may face fewer bureaucratic hurdles.")
    elif req.size == 'medium':
        score += 20
        notes.append("Medium organizations have balanced resources and agility.")
    elif req.size == 'large':
        score += 30
        notes.append("Large organizations have significant resources but may face slower decision-making.")

    # Data readiness impact
    score += req.data_readiness * 10
    notes.append(f"Data readiness level {req.data_readiness} contributes positively to the score.")

    # Governance processes impact
    if req.governance == 'yes':
        score += 25
        notes.append("Strong governance processes are in place, ensuring ethical AI adoption.")
    else:
        notes.append("Lack of governance processes may pose risks to ethical AI adoption.")

    # Final adjustments
    score = max(0, min(100, score))
    notes.append("Final score adjusted to fit within the range of 0 to 100.")

    return AssessmentResponse(score=score, notes=" ".join(notes))
