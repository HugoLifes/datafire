CREATE OR REPLACE FUNCTION add_service_and_update_project_cost(
    p_project_id INT,
    p_amount INT,
    p_service_name VARCHAR(255),
    p_cost INT
)
RETURNS VOID AS $$
BEGIN
    -- Insertar el nuevo servicio
    INSERT INTO services (project_id, amount, service, cost, create_at)
    VALUES (p_project_id, p_amount, p_service_name, p_cost, NOW());

    -- Actualizar el costo total del proyecto
    UPDATE proyectos
    SET costo = costo + p_cost
    WHERE id = p_project_id;
END;
$$ LANGUAGE plpgsql;

