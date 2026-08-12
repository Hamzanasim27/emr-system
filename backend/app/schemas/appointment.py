from datetime import datetime

from pydantic import BaseModel


class AppointmentCreate(BaseModel):
    patient_id: int
    doctor_id: int
    appointment_date: datetime
    reason: str


class AppointmentResponse(AppointmentCreate):
    id: int
    status: str

    class Config:
        from_attributes = True