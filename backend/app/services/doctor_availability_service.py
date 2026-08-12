from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.doctor_availability import DoctorAvailability


def add_availability(
    db: Session,
    data,
):
    availability = DoctorAvailability(
        doctor_id=data.doctor_id,
        day_of_week=data.day_of_week,
        start_time=data.start_time,
        end_time=data.end_time,
    )

    db.add(availability)
    db.commit()
    db.refresh(availability)

    return availability


def get_availability(
    db: Session,
    doctor_id: int,
):
    return db.query(
        DoctorAvailability
    ).filter(
        DoctorAvailability.doctor_id == doctor_id
    ).all()


def delete_availability(
    db: Session,
    availability_id: int,
):
    availability = db.query(
        DoctorAvailability
    ).filter(
        DoctorAvailability.id == availability_id
    ).first()

    if not availability:
        raise HTTPException(
            status_code=404,
            detail="Availability not found",
        )

    db.delete(availability)
    db.commit()

    return {
        "message": "Availability deleted"
    }