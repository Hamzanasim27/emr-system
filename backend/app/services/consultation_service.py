from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.consultation import Consultation


def create_consultation(db: Session, data, doctor_id: int):

    consultation = Consultation(
        patient_id=data.patient_id,
        doctor_id=doctor_id,
        diagnosis=data.diagnosis,
        clinical_notes=data.clinical_notes,
    )

    db.add(consultation)
    db.commit()
    db.refresh(consultation)

    return consultation


def get_patient_consultations(db: Session, patient_id: int):

    return (
        db.query(Consultation)
        .filter(Consultation.patient_id == patient_id)
        .order_by(Consultation.created_at.desc())
        .all()
    )


def delete_consultation(db: Session, consultation_id: int):

    consultation = (
        db.query(Consultation)
        .filter(Consultation.id == consultation_id)
        .first()
    )

    if not consultation:
        raise HTTPException(
            status_code=404,
            detail="Consultation not found",
        )

    db.delete(consultation)
    db.commit()

    return {
        "message": "Consultation deleted successfully"
    }