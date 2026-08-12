from sqlalchemy import Column, Integer, String, ForeignKey, Date
from sqlalchemy.sql import func

from app.database import Base


class Prescription(Base):
    __tablename__ = "prescriptions"

    id = Column(Integer, primary_key=True, index=True)

    patient_id = Column(Integer, ForeignKey("patients.id"))

    doctor_id = Column(Integer, ForeignKey("users.id"))

    medicines = Column(String, nullable=False)

    dosage = Column(String, nullable=False)

    instructions = Column(String, nullable=False)

    prescribed_date = Column(
        Date,
        server_default=func.current_date(),
    )