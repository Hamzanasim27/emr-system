from pydantic import BaseModel
from pydantic import EmailStr


class RegisterSchema(BaseModel):

    full_name: str

    email: EmailStr

    password: str

    role: str


class LoginSchema(BaseModel):

    email: EmailStr

    password: str


class UserResponse(BaseModel):

    id: int

    full_name: str

    email: str

    role: str

    class Config:

        from_attributes = True