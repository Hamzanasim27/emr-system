from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.clinical_note import ClinicalNote


def create_note(db: Session, data):
    note = ClinicalNote(**data.model_dump())

    db.add(note)
    db.commit()
    db.refresh(note)

    return note


def get_notes(db: Session, patient_id: int):
    return db.query(ClinicalNote).filter(
        ClinicalNote.patient_id == patient_id
    ).all()


def delete_note(db: Session, note_id: int):

    note = db.query(ClinicalNote).filter(
        ClinicalNote.id == note_id
    ).first()

    if not note:
        raise HTTPException(
            status_code=404,
            detail="Note not found",
        )

    db.delete(note)
    db.commit()

    return {"message": "Deleted successfully"}