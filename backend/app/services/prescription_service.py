from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.prescription import Prescription
from app.models.patient import Patient
from app.models.user import User
from app.schemas.prescription import PrescriptionCreate


def create_prescription(db: Session, data: PrescriptionCreate):

    patient = db.query(Patient).filter(
        Patient.id == data.patient_id
    ).first()

    if not patient:
        raise HTTPException(
            status_code=404,
            detail="Patient not found"
        )

    doctor = db.query(User).filter(
        User.id == data.doctor_id
    ).first()

    if not doctor:
        raise HTTPException(
            status_code=404,
            detail="Doctor not found"
        )

    prescription = Prescription(
        patient_id=data.patient_id,
        doctor_id=data.doctor_id,
        medicines=data.medicines,
        dosage=data.dosage,
        instructions=data.instructions,
    )

    db.add(prescription)
    db.commit()
    db.refresh(prescription)

    return prescription


def get_patient_prescriptions(
    db: Session,
    patient_id: int,
):
    return db.query(Prescription).filter(
        Prescription.patient_id == patient_id
    ).all()


def delete_prescription(
    db: Session,
    prescription_id: int,
):

    prescription = db.query(Prescription).filter(
        Prescription.id == prescription_id
    ).first()

    if not prescription:
        raise HTTPException(
            status_code=404,
            detail="Prescription not found"
        )

    db.delete(prescription)
    db.commit()

    return {
        "message": "Prescription deleted successfully"
    }