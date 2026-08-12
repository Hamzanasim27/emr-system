from sqlalchemy.orm import Session
from fastapi import HTTPException

from app.models.appointment import Appointment


def create_appointment(db: Session, appointment):
    new_appointment = Appointment(
        patient_id=appointment.patient_id,
        doctor_id=appointment.doctor_id,
        appointment_date=appointment.appointment_date,
        reason=appointment.reason,
        status="Pending",
    )

    db.add(new_appointment)
    db.commit()
    db.refresh(new_appointment)

    return new_appointment


def get_patient_appointments(db: Session, patient_id: int):
    return db.query(Appointment).filter(
        Appointment.patient_id == patient_id
    ).all()


def get_doctor_appointments(db: Session, doctor_id: int):
    return db.query(Appointment).filter(
        Appointment.doctor_id == doctor_id,
        Appointment.status == "Pending",
    ).all()


def update_status(
    db: Session,
    appointment_id: int,
    status: str,
):
    appointment = db.query(Appointment).filter(
        Appointment.id == appointment_id
    ).first()

    if not appointment:
        raise HTTPException(
            status_code=404,
            detail="Appointment not found",
        )

    appointment.status = status

    db.commit()
    db.refresh(appointment)

    return appointment


def delete_appointment(
    db: Session,
    appointment_id: int,
):
    appointment = db.query(Appointment).filter(
        Appointment.id == appointment_id
    ).first()

    if not appointment:
        raise HTTPException(
            status_code=404,
            detail="Appointment not found",
        )

    db.delete(appointment)
    db.commit()

    return {
        "message": "Appointment deleted"
    }