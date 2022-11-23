#!/bin/bash
# Copyright (c) 2022 Robert Bosch GmbH and Microsoft Corporation
#
# This program and the accompanying materials are made available under the
# terms of the Apache License, Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# SPDX-License-Identifier: Apache-2.0

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../" )

if ! k3d registry get k3d-registry.localhost &> /dev/null
then
  k3d registry create registry.localhost --port 12345
else
  echo "Registry already exists."
fi

if ! k3d cluster get cluster &> /dev/null
then
    echo "Creating cluster without proxy configuration"
    k3d cluster create cluster \
      --registry-use k3d-registry.localhost:12345 \
      -p "30555:30555" \
      -p "31883:31883" \
      -p "30051:30051" \
      --registry-use k3d-registry.localhost:12345

else
  echo "Cluster already exists."
fi


if ! dapr status -k &> /dev/null
then
  # Init Dapr in cluster. The --runtime-version is used to specify the dapr runtime version (i.e. remove the '#')
  # Dapr runtime releases: https://github.com/dapr/dapr/releases
  dapr init -k --wait --timeout 600

else
  echo "Dapr is already initialized with K3D"
fi
