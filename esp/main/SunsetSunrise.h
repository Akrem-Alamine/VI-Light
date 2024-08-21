#ifndef SUNSET_SUNRISE_H
#define SUNSET_SUNRISE_H
#include <Arduino.h>

int julianDay(int year, int month, int day);
double solarDeclination(int JD);
double hourAngle(double lat, double declination, bool isSunrise);
double calculateLocalTime(int JD, double longitude, double hourAngle, int timezone);

#endif