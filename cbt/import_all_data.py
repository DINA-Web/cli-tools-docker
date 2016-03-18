#!/usr/bin/env python

"""import_all_data.py - script for importing all available data"""

import argparse
import os

import numpy
from collectionbatchtool import *


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='A command-line script to import Specify data.')
    parser.add_argument(
        'config_file', type=argparse.FileType('rU'),
        help='path to a config-file')
    parser.add_argument(
        'input_dir', default='.', nargs='?',
        help='path to input directory')
    parser.add_argument(
        '-v', '--verbose', action='store_true')
    args = parser.parse_args()
 
    if not os.path.isdir(args.input_dir):
        msg = "%d is not valid directory" % args.input_dir
        raise argparse.ArgumentTypeError(msg)
    
    quiet = False if args.verbose else True
 

    # Files to import
    # ---------------
    # agent.csv
    # accession.csv
    # geographytreedefitem.csv
    # geography.csv
    # taxontreedefitem.csv
    # taxon.csv
    # storagetreedefitem.csv
    # storage.csv
    # locality.csv
    # collectingevent.csv
    # collectingeventattribute.csv
    # collector.csv
    # collectionobject.csv
    # collectionobjectattribute.csv
    # preptype.csv
    # preparation.csv
    # determination.csv


    apply_user_settings(args.config_file.name, quiet=quiet)

    agt = AgentDataset()
    agt.from_csv(os.path.join(args.input_dir, 'agent.csv'), quiet=quiet)
    agt.to_database(defaults={'agenttype': 1}, quiet=quiet)
    agt.update_foreign_keys(agt, quiet=quiet)
    agt.update_database_records([
        'createdbyagentid',
        'modifiedbyagentid', 
        'parentorganizationid'], quiet=quiet)

    acc = AccessionDataset()
    acc.from_csv(
        os.path.join(args.input_dir, 'accession.csv'), quiet=quiet)
    acc.update_foreign_keys(agt, quiet=quiet)
    acc.to_database(quiet=quiet)

    gtd = GeographytreedefitemDataset()
    gtd.from_csv(
        os.path.join(args.input_dir, 'geographytreedefitem.csv'),
        quiet=quiet)
    gtd.match_database_records('rankid', quiet=quiet)
    gtd.update_foreign_keys(agt, quiet=quiet)
    gtd.to_database(quiet=quiet)
    gtd.update_foreign_keys(gtd, quiet=quiet)
    gtd.update_database_records('parentitemid', quiet=quiet)

    geo = GeographyDataset()
    geo.from_csv(
        os.path.join(args.input_dir, 'geography.csv'), quiet=quiet)
    geo.match_database_records('name', quiet=quiet)
    geo.update_foreign_keys([agt, gtd], quiet=quiet)
    geo.to_database(quiet=quiet)
    geo.update_foreign_keys(geo, quiet=quiet)
    geo.update_database_records('parentid', quiet=quiet)

    ttd = TaxontreedefitemDataset()
    ttd.from_csv(
        os.path.join(args.input_dir, 'taxontreedefitem.csv'), quiet=quiet)
    ttd.match_database_records('rankid', quiet=quiet)
    ttd.to_database(quiet=quiet)
    ttd.update_foreign_keys([agt, ttd], quiet=quiet)
    ttd.update_database_records('parentitemid')

    tax = TaxonDataset()
    tax.from_csv(os.path.join(args.input_dir, 'taxon.csv'), quiet=quiet)
    tax.match_database_records('name', quiet=quiet)
    tax.update_foreign_keys([agt, ttd], quiet=quiet)
    tax.to_database(quiet=quiet, defaults={'name': 'unknown'})
    tax.update_foreign_keys(tax, quiet=quiet)
    tax.update_database_records(['acceptedid', 'parentid'], quiet=quiet)

    std = StoragetreedefitemDataset()
    std.from_csv(
        os.path.join(args.input_dir, 'storagetreedefitem.csv'),
        quiet=quiet)
    std.match_database_records('rankid', quiet=quiet)
    std.update_foreign_keys(agt, quiet=quiet)
    std.to_database(quiet=quiet)
    std.update_foreign_keys(std)
    std.update_database_records('parentitemid')

    sto = StorageDataset()
    sto.from_csv(os.path.join(args.input_dir, 'storage.csv'), quiet=quiet)
    sto.frame.loc[tax.frame.name=='Site', 'storageid'] = 1
    sto.update_foreign_keys([agt, std], quiet=quiet)
    sto.to_database(quiet=quiet, defaults={'name': 'unknown'})
    sto.update_foreign_keys(sto, quiet=quiet)
    sto.update_database_records('parentid', quiet=quiet)

    loc = LocalityDataset()
    loc.from_csv(
        os.path.join(args.input_dir, 'locality.csv'), quiet=quiet)
    loc.update_foreign_keys([agt, geo], quiet=quiet)
    loc.to_database(
        defaults={'srclatlongunit': 3, 'localityname':''}, quiet=quiet)

    cea = CollectingeventattributeDataset()
    cea.from_csv(
        os.path.join(args.input_dir, 'collectingeventattribute.csv'),
        quiet=quiet)
    cea.update_foreign_keys(agt, quiet=quiet)
    cea.to_database(quiet=quiet)

    cev = CollectingeventDataset()
    cev.from_csv(
        os.path.join(args.input_dir, 'collectingevent.csv'), quiet=quiet)
    cev.update_foreign_keys([agt, cea, loc], quiet=quiet)
    cev.to_database(quiet=quiet)

    col = CollectorDataset()
    col.from_csv(os.path.join(
        args.input_dir, 'collector.csv'), quiet=quiet)
    col.update_foreign_keys([agt, cev], quiet=quiet)
    col.to_database(defaults={'isprimary': 1}, quiet=quiet)

    coa = CollectionobjectattributeDataset()
    coa.from_csv(
        os.path.join(args.input_dir, 'collectionobjectattribute.csv'),
        quiet=quiet)
    coa.update_foreign_keys(agt, quiet=quiet)
    coa.to_database(quiet=quiet)

    cob = CollectionobjectDataset()
    cob.from_csv(
        os.path.join(args.input_dir, 'collectionobject.csv'), quiet=quiet)
    cob.update_foreign_keys([agt, cev, coa], quiet=quiet)
    cob.to_database(quiet=quiet)

    pty = PreptypeDataset()
    pty.from_csv(
        os.path.join(args.input_dir, 'preptype.csv'), quiet=quiet)
    pty.match_database_records('name')  # match existing preptypes by "name"
    pty.update_foreign_keys(agt, quiet=quiet)
    pty.to_database(defaults={'isloanable': 1}, quiet=quiet)

    pre = PreparationDataset()
    pre.from_csv(
        os.path.join(args.input_dir, 'preparation.csv'), quiet=quiet)
    pre.update_foreign_keys([agt, pty, cob], quiet=quiet)
    pre.to_database(quiet=quiet)

    det = DeterminationDataset()
    det.from_csv(os.path.join(
        args.input_dir, 'determination.csv'), quiet=quiet)
    det.update_foreign_keys([agt, cob, tax], quiet=quiet)
    det.to_database(quiet=quiet)
