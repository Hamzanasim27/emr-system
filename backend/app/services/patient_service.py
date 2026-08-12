from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.patient import Patient
from app.models.user import User
from app.schemas.patient import PatientCreate
from app.schemas.patient import PatientUpdate


def create_patient(db: Session, data: PatientCreate):

    user = db.query(User).filter(User.id == data.user_id).first()

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    patient = Patient(**data.model_dump())

    db.add(patient)
    db.commit()
    db.refresh(patient)

    return patient


def get_patients(db: Session):
    return db.query(Patient).all()


def get_patient(db: Session, patient_id: int):

    patient = db.query(Patient).filter(
        Patient.id == patient_id
    ).first()

    if not patient:
        raise HTTPException(
            status_code=404,
            detail="Patient not found"
        )

    return patient


def update_patient(
    db: Session,
    patient_id: int,
    data: PatientUpdate,
):

    patient = get_patient(db, patient_id)

    for key, value in data.model_dump(exclude_unset=True).items():
        setattr(patient, key, value)

    db.commit()
    db.refresh(patient)

    return patient


def delete_patient(
    db: Session,
    patient_id: int,
):

    patient = get_patient(db, patient_id)

    db.delete(patient)
    db.commit()

    return {
        "message": "Patient deleted successfully"
    }