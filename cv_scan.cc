#include <iostream>
#include <fstream>
#include <iomanip>
#include <streambuf>

#include <file_io_utils.h>

#include "Kde2d.h"
#include "ProdKde2d.h"

using namespace std;

// perform cross validation scan over bandwidths
int main(int argc, char *argv[]) {

  if (argc < 7) {
    cerr << endl;
    cerr << "usage: ./cv_scan output_fname data_fname colnum begin end step" << endl;
    cerr << endl;
    cerr << left << setfill('.');
    cerr << setw(30) << "output_fname" <<  "file to save results. " << endl;
    cerr << setw(30) << "data_fname" << "file name of the data sample. " << endl;
    cerr << setw(30) << "colnum" << "column to cross validate. 0: first, 1: second. " << endl;
    cerr << setw(30) << "begin, end, and step" << "scan bandwidths starting from <begin>. " << endl;
    cerr << setw(30) << setfill(' ') << "" << "subsequent scans are done at <step> *decrements*. " << endl; 
    cerr << setw(30) << setfill(' ') << "" << "scan stops just before we scan past end. " << endl;
                                              
    cerr << endl;
    return 1;
  }

  vector<double> candidates;
  double begin = stod(argv[4]), end = stod(argv[5]), step = stod(argv[6]);
  for (int i = 0; begin - i * step >= end; ++i) {
    candidates.push_back(begin - i * step);
  }

  bool cv_x1 = stoi(argv[3]) ? false : true;

  ProdKde2d kde(argv[2]);

  ofstream fout;
  open_for_writing(fout, argv[1]);

  double cv_min = 0.0, cv_argmin = 0.0;
  vector<double> results;
  for (auto &h : candidates) {
    kde.cv(results, h, cv_x1);
    if (results[2] < cv_min) { cv_min = results[2]; cv_argmin = h; }

    fout << h << " ";
    fout << results[1] << " ";
    fout << results[2] << endl;

    cout << h << " ";
    cout << results[1] << " ";
    cout << results[2] << endl;
  }
  fout.close();

  cout << "best cv = " << cv_min << ", best h = " << cv_argmin << endl;


  return 0;

}
