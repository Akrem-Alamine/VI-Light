#include "SunsetSunrise.h"
#include <math.h>
#define DEG_TO_RAD 0.017453292519943295769236907684886

int julianDay(int year, int month, int day) {
    if (month <= 2) {
        year -= 1;
        month += 12;
    }
    int A = year / 100;
    int B = 2 - A + (A / 4);
    int JD = int(365.25 * (year + 4716)) + int(30.6001 * (month + 1)) + day + B - 1524;
    return JD;
}
double solarDeclination(int JD) {
    double n = JD - 2451545.0;  // Days since 1 January 2000
    double L = fmod(280.460 + 0.9856474 * n, 360.0);  // Mean longitude of the Sun
    double g = fmod(357.528 + 0.9856003 * n, 360.0);  // Mean anomaly of the Sun
    double lambda = L + 1.915 * sin(g * DEG_TO_RAD) + 0.020 * sin(2 * g * DEG_TO_RAD);  // Ecliptic longitude
    return asin(sin(lambda * DEG_TO_RAD) * sin(23.44 * DEG_TO_RAD));  // Declination
}

double hourAngle(double lat, double declination, bool isSunrise) {
    double latRad = lat * DEG_TO_RAD;
    double cosH = (cos(90.833 * DEG_TO_RAD) - sin(latRad) * sin(declination)) / (cos(latRad) * cos(declination));
    if (isSunrise) {
        return -acos(cosH) / DEG_TO_RAD;  // Sunrise
    } else {
        return acos(cosH) / DEG_TO_RAD;  // Sunset
    }
}

// Local time calculation function with time zone adjustment (UTC+1 for Tunis)
double calculateLocalTime(int JD, double longitude, double hourAngle, int timezone) {
    double solarNoon = (720.0 - 4.0 * longitude - hourAngle * 4.0);  // Solar noon in minutes
    return solarNoon + timezone * 60.0;  // Local time in minutes from midnight
}