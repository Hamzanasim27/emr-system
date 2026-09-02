from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.consultation import Consultation
from app.models.clinical_note import ClinicalNote
from app.services.soap_service import generate_soap_note

router = APIRouter(
    prefix="/soap",
    tags=["SOAP Notes"],
)


# Generate and save SOAP note
@router.post("/generate/{consultation_id}")
def generate(
    consultation_id: int,
    db: Session = Depends(get_db),
):
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

    try:
        # Generate SOAP note using OpenRouter
        soap_note = generate_soap_note(
            diagnosis=consultation.diagnosis,
            clinical_notes=consultation.clinical_notes,
        )

        # Save SOAP note into clinical_notes table
        new_note = ClinicalNote(
            patient_id=consultation.patient_id,
            doctor_id=consultation.doctor_id,
            consultation_id=consultation.id,
            note=soap_note,
            note_type="soap",
        )

        db.add(new_note)
        db.commit()
        db.refresh(new_note)

        return {
            "id": new_note.id,
            "consultation_id": consultation.id,
            "patient_id": consultation.patient_id,
            "doctor_id": consultation.doctor_id,
            "soap_note": new_note.note,
            "created_at": new_note.created_at,
            "message": "SOAP note generated and saved successfully",
        }

    except Exception as e:
        db.rollback()

        raise HTTPException(
            status_code=500,
            detail=f"SOAP generation failed: {str(e)}",
        )


# View / See saved SOAP note
@router.get("/{note_id}")
def get_soap_note(
    note_id: int,
    db: Session = Depends(get_db),
):
    note = (
        db.query(ClinicalNote)
        .filter(
            ClinicalNote.id == note_id,
            ClinicalNote.note_type == "soap",
        )
        .first()
    )

    if not note:
        raise HTTPException(
            status_code=404,
            detail="SOAP note not found",
        )

    return {
        "id": note.id,
        "patient_id": note.patient_id,
        "doctor_id": note.doctor_id,
        "soap_note": note.note,
        "created_at": note.created_at,
    }


# Delete saved SOAP note
@router.delete("/{note_id}")
def delete_soap_note(
    note_id: int,
    db: Session = Depends(get_db),
):
    note = (
        db.query(ClinicalNote)
        .filter(
            ClinicalNote.id == note_id,
            ClinicalNote.note_type == "soap",
        )
        .first()
    )

    if not note:
        raise HTTPException(
            status_code=404,
            detail="SOAP note not found",
        )

    db.delete(note)
    db.commit()

    return {
        "message": "SOAP note deleted successfully",
        "id": note_id,
    }