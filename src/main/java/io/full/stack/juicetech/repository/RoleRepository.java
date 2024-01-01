package io.full.stack.juicetech.repository;

import io.full.stack.juicetech.domain.Role;

import java.util.Collection;

public interface RoleRepository <T extends Role> {
    //Basic crud
    T create(T data);

    Collection<T> list(int page, int pageSize);

    T get(Long id);

    T update(T data);

    Boolean delete(Long id);

    //More complex ops
    void addRoleToUser(Long userId, String roleName);
}
