-- CreateTable
CREATE TABLE "Routes_tbl" (
    "id" SERIAL NOT NULL,
    "id_device" INTEGER NOT NULL,
    "longitude" TEXT,
    "latitude" TEXT,
    "speed" TEXT,
    "date" TIMESTAMP(3),

    CONSTRAINT "Routes_tbl_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Alerts_tbl" (
    "id" SERIAL NOT NULL,
    "id_device" INTEGER NOT NULL,
    "id_alert" INTEGER NOT NULL,
    "description" TEXT,
    "latitude" TEXT,
    "longitude" TEXT,
    "date" TIMESTAMP(3),

    CONSTRAINT "Alerts_tbl_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Summary_tbl" (
    "id" SERIAL NOT NULL,
    "id_device" INTEGER NOT NULL,
    "average_speed" DOUBLE PRECISION,
    "distance" DOUBLE PRECISION,
    "initial_datetime" TIMESTAMP(3),
    "max_speed" DOUBLE PRECISION,
    "spent_fuel" DOUBLE PRECISION,
    "final_datetime" TIMESTAMP(3),

    CONSTRAINT "Summary_tbl_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Camera_tbl" (
    "id" SERIAL NOT NULL,
    "name" TEXT,
    "actual_status" TEXT,
    "last_update" TIMESTAMP(3),
    "contact" TEXT,
    "latitude" TEXT,
    "longitude" TEXT,
    "altitude" TEXT,
    "city" TEXT,
    "country" TEXT,
    "camera_brand" TEXT,
    "ip" TEXT,
    "password" TEXT,
    "stream" TEXT,
    "status" TEXT,

    CONSTRAINT "Camera_tbl_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Camera_user" (
    "id_camera" INTEGER NOT NULL,
    "id_user" INTEGER NOT NULL,

    CONSTRAINT "Camera_user_pkey" PRIMARY KEY ("id_camera","id_user")
);

-- CreateTable
CREATE TABLE "Cameras_Devices" (
    "id_camera" INTEGER NOT NULL,
    "id_device" INTEGER NOT NULL,

    CONSTRAINT "Cameras_Devices_pkey" PRIMARY KEY ("id_camera","id_device")
);

-- CreateTable
CREATE TABLE "Devices_tbl" (
    "id" SERIAL NOT NULL,
    "group_id" INTEGER NOT NULL,
    "name" TEXT,
    "device_status" TEXT,
    "last_update" TIMESTAMP(3),
    "phone" TEXT,
    "model" TEXT,
    "fuel_type" TEXT,
    "km_per_liter" DOUBLE PRECISION,
    "is_over" BOOLEAN,
    "status" TIMESTAMP(3),

    CONSTRAINT "Devices_tbl_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User_devices" (
    "id_device" INTEGER NOT NULL,
    "id_user" INTEGER NOT NULL,

    CONSTRAINT "User_devices_pkey" PRIMARY KEY ("id_device","id_user")
);

-- CreateTable
CREATE TABLE "User_geofences" (
    "id_geofence" INTEGER NOT NULL,
    "id_user" INTEGER NOT NULL,

    CONSTRAINT "User_geofences_pkey" PRIMARY KEY ("id_geofence","id_user")
);

-- CreateTable
CREATE TABLE "User_tbl" (
    "id" SERIAL NOT NULL,
    "first_name" TEXT,
    "last_name" TEXT,
    "email" TEXT NOT NULL,
    "password" TEXT,
    "phone" TEXT,
    "profile_id" INTEGER NOT NULL,
    "birthdate" TIMESTAMP(3),
    "status" TIMESTAMP(3),

    CONSTRAINT "User_tbl_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Geofences_tbl" (
    "id" SERIAL NOT NULL,
    "name" TEXT,
    "description" TEXT,
    "color" TEXT,
    "status" TIMESTAMP(3),

    CONSTRAINT "Geofences_tbl_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Profile_tbl" (
    "id" SERIAL NOT NULL,
    "profile" TEXT,
    "status" TIMESTAMP(3),

    CONSTRAINT "Profile_tbl_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Group_tbl" (
    "id" SERIAL NOT NULL,
    "group_name" TEXT,
    "status" TIMESTAMP(3),

    CONSTRAINT "Group_tbl_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Alert_type_tbl" (
    "id" SERIAL NOT NULL,
    "alert" TEXT,
    "color" TEXT,
    "status" TIMESTAMP(3),

    CONSTRAINT "Alert_type_tbl_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_tbl_email_key" ON "User_tbl"("email");

-- AddForeignKey
ALTER TABLE "Routes_tbl" ADD CONSTRAINT "Routes_tbl_id_device_fkey" FOREIGN KEY ("id_device") REFERENCES "Devices_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Alerts_tbl" ADD CONSTRAINT "Alerts_tbl_id_device_fkey" FOREIGN KEY ("id_device") REFERENCES "Devices_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Alerts_tbl" ADD CONSTRAINT "Alerts_tbl_id_alert_fkey" FOREIGN KEY ("id_alert") REFERENCES "Alert_type_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Summary_tbl" ADD CONSTRAINT "Summary_tbl_id_device_fkey" FOREIGN KEY ("id_device") REFERENCES "Devices_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Camera_user" ADD CONSTRAINT "Camera_user_id_camera_fkey" FOREIGN KEY ("id_camera") REFERENCES "Camera_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cameras_Devices" ADD CONSTRAINT "Cameras_Devices_id_camera_fkey" FOREIGN KEY ("id_camera") REFERENCES "Camera_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cameras_Devices" ADD CONSTRAINT "Cameras_Devices_id_device_fkey" FOREIGN KEY ("id_device") REFERENCES "Devices_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Devices_tbl" ADD CONSTRAINT "Devices_tbl_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "Group_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User_devices" ADD CONSTRAINT "User_devices_id_device_fkey" FOREIGN KEY ("id_device") REFERENCES "Devices_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User_devices" ADD CONSTRAINT "User_devices_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "User_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User_geofences" ADD CONSTRAINT "User_geofences_id_geofence_fkey" FOREIGN KEY ("id_geofence") REFERENCES "Geofences_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User_geofences" ADD CONSTRAINT "User_geofences_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "User_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User_tbl" ADD CONSTRAINT "User_tbl_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "Profile_tbl"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
