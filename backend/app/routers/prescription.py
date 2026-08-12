from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.prescription import PrescriptionCreate
from app.services.prescription_service import (
    create_prescription,
    get_patient_prescriptions,
    delete_prescription,
)
from app.dependencies.auth import get_current_user
from app.models.patient import Patient

router = APIRouter(
    prefix="/prescriptions",
    tags=["Prescriptions"],
)


@router.post("/")
def create(
    data: PrescriptionCreate,
    db: Session = Depends(get_db),
):
    return create_prescription(db, data)


@router.get("/me")
def my_prescriptions(
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    patient = db.query(Patient).filter(
        Patient.user_id == current_user.id
    ).first()

    return get_patient_prescriptions(
        db,
        patient.id,
    )


@router.get("/{patient_id}")
def all(
    patient_id: int,
    db: Session = Depends(get_db),
):
    return get_patient_prescriptions(
        db,
        patient_id,
    )


@router.delete("/{prescription_id}")
def delete(
    prescription_id: int,
    db: Session = Depends(get_db),
):
    return delete_prescription(
        db,
        prescription_id,
    )