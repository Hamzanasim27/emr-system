from datetime import date
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies.auth import get_current_user
from app.models.patient import Patient
from app.models.user import User
from app.schemas.patient import PatientCreate, PatientUpdate

from app.services.patient_service import (
    create_patient,
    get_patients,
    get_patient,
    update_patient,
    delete_patient,
)

router = APIRouter(
    prefix="/patients",
    tags=["Patients"],
)


@router.post("/")
def create(
    data: PatientCreate,
    db: Session = Depends(get_db),
):
    return create_patient(db, data)


@router.get("/me")
def my_profile(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    patient = (
        db.query(Patient)
        .filter(Patient.user_id == current_user.id)
        .first()
    )

    if patient:
        return patient

    # Return empty profile if not created yet
    return {
        "id": None,
        "user_id": current_user.id,
        "date_of_birth": date.today(),
        "gender": "",
        "blood_group": "",
        "phone": "",
        "address": "",
        "emergency_contact": "",
        "allergies": "",
        "medical_history": "",
        "current_medications": "",
    }


@router.put("/me")
def update_my_profile(
    data: PatientUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    patient = (
        db.query(Patient)
        .filter(Patient.user_id == current_user.id)
        .first()
    )

    if patient is None:
        patient = Patient(
            user_id=current_user.id,
            date_of_birth=data.date_of_birth or date.today(),
            gender=data.gender or "",
            blood_group=data.blood_group or "",
            phone=data.phone or "",
            address=data.address or "",
            emergency_contact=data.emergency_contact or "",
            allergies=data.allergies or "",
            medical_history=data.medical_history or "",
            current_medications=data.current_medications or "",
        )

        db.add(patient)
    else:
        for key, value in data.model_dump(exclude_unset=True).items():
            setattr(patient, key, value)

    db.commit()
    db.refresh(patient)

    return patient


@router.get("/")
def all(
    db: Session = Depends(get_db),
):
    return get_patients(db)


@router.get("/{patient_id}")
def one(
    patient_id: int,
    db: Session = Depends(get_db),
):
    return get_patient(db, patient_id)


@router.put("/{patient_id}")
def update(
    patient_id: int,
    data: PatientUpdate,
    db: Session = Depends(get_db),
):
    return update_patient(db, patient_id, data)


@router.delete("/{patient_id}")
def delete(
    patient_id: int,
    db: Session = Depends(get_db),
):
    return delete_patient(db, patient_id)