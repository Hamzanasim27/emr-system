from pydantic import BaseModel
from datetime import datetime


class ClinicalNoteCreate(BaseModel):
    patient_id: int
    doctor_id: int
    note: str


class ClinicalNoteResponse(BaseModel):
    id: int
    patient_id: int
    doctor_id: int
    note: str
    created_at: datetime

    class Config:
        from_attributes = True