from fastapi import APIRouter
from fastapi import Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.appointment import AppointmentCreate
from app.services.appointment_service import (
    create_appointment,
    get_patient_appointments,
    get_doctor_appointments,
    update_status,
    delete_appointment,
)

router = APIRouter(
    prefix="/appointments",
    tags=["Appointments"],
)


@router.post("/")
def create(
    appointment: AppointmentCreate,
    db: Session = Depends(get_db),
):
    return create_appointment(
        db,
        appointment,
    )


@router.get("/patient/{patient_id}")
def patient(
    patient_id: int,
    db: Session = Depends(get_db),
):
    return get_patient_appointments(
        db,
        patient_id,
    )


@router.get("/doctor/{doctor_id}")
def doctor(
    doctor_id: int,
    db: Session = Depends(get_db),
):
    return get_doctor_appointments(
        db,
        doctor_id,
    )


@router.put("/{appointment_id}/{status}")
def update(
    appointment_id: int,
    status: str,
    db: Session = Depends(get_db),
):
    return update_status(
        db,
        appointment_id,
        status,
    )


@router.delete("/{appointment_id}")
def delete(
    appointment_id: int,
    db: Session = Depends(get_db),
):
    return delete_appointment(
        db,
        appointment_id,
    )