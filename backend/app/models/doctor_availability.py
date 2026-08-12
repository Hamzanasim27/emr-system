from sqlalchemy import Column, Integer, String, ForeignKey

from app.database import Base


class DoctorAvailability(Base):
    __tablename__ = "doctor_availability"

    id = Column(Integer, primary_key=True, index=True)

    doctor_id = Column(
        Integer,
        ForeignKey("users.id"),   # <-- CHANGE THIS
        nullable=False,
    )

    day_of_week = Column(String, nullable=False)
    start_time = Column(String, nullable=False)
    end_time = Column(String, nullable=False)