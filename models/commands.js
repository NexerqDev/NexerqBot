module.exports = function(sequelize, DataTypes) {
  var Commands = sequelize.define("commands", {
    channel: DataTypes.STRING,
    command: DataTypes.STRING,
    output: DataTypes.STRING,
    count: DataTypes.INTEGER,
    addedBy: DataTypes.STRING
  });

  return Commands;
};