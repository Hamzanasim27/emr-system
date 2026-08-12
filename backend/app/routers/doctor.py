from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.services.doctor_service import get_all_patients
from app.services.doctor_service import (
    get_all_doctors,
)
router = APIRouter(
    prefix="/doctor",
    tags=["Doctor"],
)


@router.get("/patients")
def patients(
    db: Session = Depends(get_db),
):
    return get_all_patients(db)

@router.get("/")
def doctors(
    db: Session = Depends(get_db),
):
    return get_all_doctors(db)