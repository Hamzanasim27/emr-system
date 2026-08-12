from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.consultation import ConsultationCreate
from app.services.consultation_service import (
    create_consultation,
    get_patient_consultations,
    delete_consultation,
)
from app.dependencies.auth import get_current_user
from app.models.patient import Patient

router = APIRouter(
    prefix="/consultations",
    tags=["Consultations"],
)


@router.post("/")
def create(
    data: ConsultationCreate,
    db: Session = Depends(get_db),
):
    # Temporary doctor id
    return create_consultation(
        db,
        data,
        doctor_id=1,
    )


@router.get("/me")
def my_consultations(
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    patient = db.query(Patient).filter(
        Patient.user_id == current_user.id
    ).first()

    return get_patient_consultations(
        db,
        patient.id,
    )


@router.get("/{patient_id}")
def patient_history(
    patient_id: int,
    db: Session = Depends(get_db),
):
    return get_patient_consultations(
        db,
        patient_id,
    )


@router.delete("/{consultation_id}")
def delete(
    consultation_id: int,
    db: Session = Depends(get_db),
):
    return delete_consultation(
        db,
        consultation_id,
    )