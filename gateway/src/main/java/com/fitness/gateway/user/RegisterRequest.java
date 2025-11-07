package com.fitness.gateway.user;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import javax.crypto.Mac;

@Data
public class RegisterRequest {

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email")
    private String email;
    @NotBlank(message = "password is requird ")
    @Size(min=6, message = "must be atleast 6 character")
    private String password;
    private String keycloakId;

    private String firstName;
    private String lastName;


}
