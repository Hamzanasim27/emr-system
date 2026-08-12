from pydantic import BaseModel


class AvailabilityCreate(BaseModel):
    doctor_id: int
    day_of_week: str
    start_time: str
    end_time: str


class AvailabilityResponse(AvailabilityCreate):
    id: int

    class Config:
        from_attributes = True