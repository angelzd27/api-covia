/*
  Warnings:

  - You are about to drop the column `initial_datetime` on the `Summary_tbl` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Geofences_tbl" ADD COLUMN     "area" TEXT;

-- AlterTable
ALTER TABLE "Summary_tbl" DROP COLUMN "initial_datetime",
ADD COLUMN     "initial_odometer" TIMESTAMP(3),
ADD COLUMN     "km_per_liter" DOUBLE PRECISION;
