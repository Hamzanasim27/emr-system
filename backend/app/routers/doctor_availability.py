from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.doctor_availability import AvailabilityCreate
from app.services.doctor_availability_service import (
    add_availability,
    get_availability,
    delete_availability,
)

router = APIRouter(
    prefix="/availability",
    tags=["Doctor Availability"],
)


@router.post("/")
def create(
    data: AvailabilityCreate,
    db: Session = Depends(get_db),
):
    return add_availability(
        db,
        data,
    )


@router.get("/{doctor_id}")
def list_availability(
    doctor_id: int,
    db: Session = Depends(get_db),
):
    return get_availability(
        db,
        doctor_id,
    )


@router.delete("/{availability_id}")
def remove(
    availability_id: int,
    db: Session = Depends(get_db),
):
    return delete_availability(
        db,
        availability_id,
    )