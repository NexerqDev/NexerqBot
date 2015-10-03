module.exports = function(sequelize, DataTypes) {
  var Commands = sequelize.define("commands", {
    channel: DataTypes.STRING,
    command: DataTypes.STRING,
    output: DataTypes.STRING,
    count: {type: DataTypes.INTEGER, defaultValue: 0},
    addedBy: DataTypes.STRING
  });

  return Commands;
};