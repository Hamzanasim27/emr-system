from pydantic import BaseModel


class PrescriptionCreate(BaseModel):
    patient_id: int
    doctor_id: int
    medicines: str
    dosage: str
    instructions: str


class PrescriptionResponse(PrescriptionCreate):
    id: int

    class Config:
        from_attributes = True