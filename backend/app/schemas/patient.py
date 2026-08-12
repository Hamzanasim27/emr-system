from datetime import date
from typing import Optional

from pydantic import BaseModel


class PatientCreate(BaseModel):
    user_id: int
    date_of_birth: date
    gender: str
    blood_group: str
    phone: str
    address: str
    emergency_contact: str
    allergies: Optional[str] = None
    medical_history: Optional[str] = None
    current_medications: Optional[str] = None


class PatientUpdate(BaseModel):
    date_of_birth: Optional[date] = None
    gender: Optional[str] = None
    blood_group: Optional[str] = None
    phone: Optional[str] = None
    address: Optional[str] = None
    emergency_contact: Optional[str] = None
    allergies: Optional[str] = None
    medical_history: Optional[str] = None
    current_medications: Optional[str] = None


class PatientResponse(BaseModel):
    id: int
    user_id: int

    date_of_birth: date

    gender: str

    blood_group: str

    phone: str

    address: str

    emergency_contact: str

    allergies: Optional[str]

    medical_history: Optional[str]

    current_medications: Optional[str]

    class Config:
        from_attributes = True