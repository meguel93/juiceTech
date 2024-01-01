package io.full.stack.juicetech.repository;

import io.full.stack.juicetech.domain.Role;
import io.full.stack.juicetech.domain.User;
import io.full.stack.juicetech.enums.RoleTypes;
import io.full.stack.juicetech.exception.ApiException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Repository;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.Collection;
import java.util.Map;
import java.util.UUID;

import static io.full.stack.juicetech.enums.VerificationType.ACCOUNT;
import static io.full.stack.juicetech.query.UserQuery.*;
import static java.util.Objects.*;

@Repository
@RequiredArgsConstructor
@Slf4j
public class UserRepositoryImpl implements UserRepository<User> {

    private final NamedParameterJdbcTemplate jdbc;

    private final RoleRepository<Role> roleRepository;

    private final BCryptPasswordEncoder encoder;

    @Override
    public User create(User user) {
        //Check if the email is unique
        if (getEmailCount(user.getEmail().trim().toLowerCase()) > 0)
            throw new ApiException("Email already in use. Please use a different email");

        //Save new user
        try {
            KeyHolder holder = new GeneratedKeyHolder();

            SqlParameterSource parameterSource = getSqlParameterSource(user);
            jdbc.update(INSERT_USER_QUERY, parameterSource, holder);

            user.setId(requireNonNull(holder.getKey()).longValue());

            //Add role to the user
            roleRepository.addRoleToUser(user.getId(), RoleTypes.ROLE_USER.name());

            //Send verification url
            String verificationURL = getVerificationUrl(UUID.randomUUID().toString(), ACCOUNT.getType());

            //Save url in verification table
            jdbc.update(INSERT_VERIFICATION_QUERY, Map.of("userId", user.getId(), "url", verificationURL));

            //Send email to user with verification //return the newly created user
//            emailService.sendverificationUrl(user.getFirstName(), user.getEmail(), verificationURL, ACCOUNT);
            user.setEnable(false);
            user.setNotLocked(true);

            return user;
            //if any errors, throw execution with message
        } catch (EmptyResultDataAccessException exception) {
            throw new ApiException("No role found by name: " + RoleTypes.ROLE_USER.name());
        } catch (Exception exception) {
            throw new ApiException("An error occured. Please try again");
        }
    }

    @Override
    public Collection<User> list(int page, int pageSize) {
        return null;
    }

    @Override
    public User get(Long id) {
        return null;
    }

    @Override
    public User update(User data) {
        return null;
    }

    @Override
    public Boolean delete(Long id) {
        return null;
    }

    private int getEmailCount(String email) {
        return jdbc.queryForObject(COUNT_USER_EMAIL_QUERY, Map.of("email", email), Integer.class);
    }

    private SqlParameterSource getSqlParameterSource(User user) {
        return new MapSqlParameterSource()
                .addValue("firstName", user.getFirstName())
                .addValue("lastName", user.getLastName())
                .addValue("email", user.getEmail())
                .addValue("password", encoder.encode(user.getPassword()));
    }

    private String getVerificationUrl(String key, String type) {
        return ServletUriComponentsBuilder.fromCurrentContextPath().path("/user/verify/" + type + "/" + key).toUriString();
    }
}




































