from sqlalchemy.orm import Session

from app.models.patient import Patient
from app.models.user import User


def get_all_patients(db: Session):
    patients = (
        db.query(Patient, User)
        .join(User, Patient.user_id == User.id)
        .all()
    )
    result = []
    for patient, user in patients:
        result.append({
            "id": patient.id,
            "user_id": user.id,
            "full_name": user.full_name,
            "email": user.email,
            "gender": patient.gender,
            "blood_group": patient.blood_group,
        })
    return result


def get_all_doctors(db: Session):
    return db.query(User).filter(
        User.role == "doctor"
    ).all()