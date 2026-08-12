from pydantic import BaseModel
from datetime import datetime


class ConsultationCreate(BaseModel):
    patient_id: int
    diagnosis: str
    clinical_notes: str


class ConsultationResponse(BaseModel):
    id: int
    patient_id: int
    doctor_id: int
    diagnosis: str
    clinical_notes: str
    created_at: datetime

    class Config:
        from_attributes = True