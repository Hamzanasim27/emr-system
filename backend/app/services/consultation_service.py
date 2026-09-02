from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.consultation import Consultation
from app.models.clinical_note import ClinicalNote


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
    consultations = (
        db.query(Consultation)
        .filter(Consultation.patient_id == patient_id)
        .order_by(Consultation.created_at.desc())
        .all()
    )

    result = []

    for consultation in consultations:

        soap_note = (
            db.query(ClinicalNote)
            .filter(
                ClinicalNote.consultation_id == consultation.id,
                ClinicalNote.note_type == "soap",
            )
            .order_by(ClinicalNote.created_at.desc())
            .first()
        )

        result.append({
            "id": consultation.id,
            "patient_id": consultation.patient_id,
            "doctor_id": consultation.doctor_id,
            "diagnosis": consultation.diagnosis,
            "clinical_notes": consultation.clinical_notes,
            "created_at": consultation.created_at,
            "soap_note_id": soap_note.id if soap_note else None,
        })

    return result


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