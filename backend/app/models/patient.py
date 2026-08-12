from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship

from app.database import Base


class Patient(Base):
    __tablename__ = "patients"

    id = Column(Integer, primary_key=True, index=True)

    user_id = Column(Integer, ForeignKey("users.id"), unique=True)

    date_of_birth = Column(Date)

    gender = Column(String)

    blood_group = Column(String)

    phone = Column(String)

    address = Column(String)

    emergency_contact = Column(String)

    allergies = Column(String)

    medical_history = Column(String)

    current_medications = Column(String)

    user = relationship("User")