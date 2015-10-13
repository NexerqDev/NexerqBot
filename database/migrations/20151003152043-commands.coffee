module.exports =
    up: (queryInterface, Sequelize) ->
        return queryInterface.createTable 'commands',
            id:
                type: Sequelize.INTEGER
                primaryKey: true
                autoIncrement: true
            channel: Sequelize.STRING
            command: Sequelize.STRING
            output: Sequelize.STRING
            count: Sequelize.INTEGER
            addedBy: Sequelize.STRING
            createdAt:
                type: Sequelize.DATE
            updatedAt:
                type: Sequelize.DATE

    down: (queryInterface, Sequelize) ->
        return queryInterface.dropTable 'commands'
