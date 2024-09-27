'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Agrega una función para actualizar el 'costo' en la tabla de proyectos al insertar un nuevo servicio
    await queryInterface.sequelize.query(`
      CREATE OR REPLACE FUNCTION actualizar_costo_proyecto_al_insertar_servicio(nuevo_costo INT, proyecto_id INT) RETURNS VOID AS $$
      BEGIN
        UPDATE proyectos
        SET costo = costo + nuevo_costo
        WHERE id = proyecto_id;
      END;
      $$ LANGUAGE plpgsql;
    `);

    // Agrega un disparador para invocar la función al insertar un servicio
    await queryInterface.sequelize.query(`
      CREATE TRIGGER trigger_actualizar_costo_proyecto_al_insertar_servicio
      AFTER INSERT ON services
      FOR EACH ROW
      EXECUTE FUNCTION actualizar_costo_proyecto_al_insertar_servicio(NEW.cost, NEW.project_id);
    `);

    // Agrega una función para actualizar el 'costo' en la tabla de proyectos al eliminar un servicio
    await queryInterface.sequelize.query(`
      CREATE OR REPLACE FUNCTION actualizar_costo_proyecto_al_eliminar_servicio(costo_eliminar INT, proyecto_id INT) RETURNS VOID AS $$
      BEGIN
        UPDATE proyectos
        SET costo = costo - costo_eliminar
        WHERE id = proyecto_id;
      END;
      $$ LANGUAGE plpgsql;
    `);

    // Agrega un disparador para invocar la función al eliminar un servicio
    await queryInterface.sequelize.query(`
      CREATE TRIGGER trigger_actualizar_costo_proyecto_al_eliminar_servicio
      AFTER DELETE ON services
      FOR EACH ROW
      EXECUTE FUNCTION actualizar_costo_proyecto_al_eliminar_servicio(OLD.cost, OLD.project_id);
    `);
  },

  down: async (queryInterface, Sequelize) => {
    // Elimina los disparadores
    await queryInterface.sequelize.query(`
      DROP TRIGGER IF EXISTS trigger_actualizar_costo_proyecto_al_insertar_servicio ON services;
    `);

    await queryInterface.sequelize.query(`
      DROP TRIGGER IF EXISTS trigger_actualizar_costo_proyecto_al_eliminar_servicio ON services;
    `);

    // Elimina las funciones
    await queryInterface.sequelize.query(`
      DROP FUNCTION IF EXISTS actualizar_costo_proyecto_al_insertar_servicio(INT, INT);
    `);

    await queryInterface.sequelize.query(`
      DROP FUNCTION IF EXISTS actualizar_costo_proyecto_al_eliminar_servicio(INT, INT);
    `);
  },
};
