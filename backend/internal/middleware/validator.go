package middleware

import (
	"net/http"
	"regexp"

	"github.com/gin-gonic/gin"
)

var (
	emailRegex = regexp.MustCompile(`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`)
	phoneRegex = regexp.MustCompile(`^\d{9}$`)
	plateRegex = regexp.MustCompile(`^[A-Z]{3}-\d{3}$`)
)

type ValidationError struct {
	Field   string `json:"field"`
	Message string `json:"message"`
}

func ValidateEmail(email string) *ValidationError {
	if email == "" {
		return &ValidationError{
			Field:   "email",
			Message: "El email es requerido",
		}
	}

	if !emailRegex.MatchString(email) {
		return &ValidationError{
			Field:   "email",
			Message: "El formato del email es inválido",
		}
	}

	return nil
}

func ValidatePassword(password string) *ValidationError {
	if password == "" {
		return &ValidationError{
			Field:   "password",
			Message: "La contraseña es requerida",
		}
	}

	if len(password) < 6 {
		return &ValidationError{
			Field:   "password",
			Message: "La contraseña debe tener al menos 6 caracteres",
		}
	}

	if len(password) > 100 {
		return &ValidationError{
			Field:   "password",
			Message: "La contraseña es demasiado larga",
		}
	}

	return nil
}

func ValidateName(name string) *ValidationError {
	if name == "" {
		return &ValidationError{
			Field:   "name",
			Message: "El nombre es requerido",
		}
	}

	if len(name) < 2 {
		return &ValidationError{
			Field:   "name",
			Message: "El nombre debe tener al menos 2 caracteres",
		}
	}

	if len(name) > 100 {
		return &ValidationError{
			Field:   "name",
			Message: "El nombre es demasiado largo",
		}
	}

	return nil
}

func ValidatePhone(phone string) *ValidationError {
	if phone == "" {
		return &ValidationError{
			Field:   "phone",
			Message: "El teléfono es requerido",
		}
	}

	if !phoneRegex.MatchString(phone) {
		return &ValidationError{
			Field:   "phone",
			Message: "El teléfono debe tener 9 dígitos",
		}
	}

	return nil
}

func ValidatePlate(plate string) *ValidationError {
	if plate == "" {
		return &ValidationError{
			Field:   "plate",
			Message: "La placa es requerida",
		}
	}

	if !plateRegex.MatchString(plate) {
		return &ValidationError{
			Field:   "plate",
			Message: "La placa debe tener el formato ABC-123",
		}
	}

	return nil
}

func RespondWithValidationErrors(c *gin.Context, errors []*ValidationError) {
	errorMap := make(map[string]string)
	for _, err := range errors {
		errorMap[err.Field] = err.Message
	}

	c.JSON(http.StatusBadRequest, gin.H{
		"error":  "Validation failed",
		"errors": errorMap,
	})
}
