from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.schemas.clinical_note import (
    ClinicalNoteCreate,
)
from app.services.clinical_note_service import (
    create_note,
    get_notes,
    delete_note,
)

router = APIRouter(
    prefix="/clinical-notes",
    tags=["Clinical Notes"],
)


@router.post("/")
def create(
    data: ClinicalNoteCreate,
    db: Session = Depends(get_db),
):
    return create_note(db, data)


@router.get("/{patient_id}")
def all_notes(
    patient_id: int,
    db: Session = Depends(get_db),
):
    return get_notes(db, patient_id)


@router.delete("/{note_id}")
def remove(
    note_id: int,
    db: Session = Depends(get_db),
):
    return delete_note(db, note_id)